module "network" {
	source = "./modules/network"
	
	vpc-cidr-block = "10.0.0.0/16"
	vpc-name = "main"
	subnets-cidr-block = ["10.0.0.0/24", "10.0.1.0/24"]
	subnets-name = ["master-subnet", "slave-subnet"]
	availability_zones = ["us-east-1a", "us-east-1b"]
	public-subnet = [true, true]
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "dev-key"
  public_key = tls_private_key.private_key.public_key_openssh
}

resource "local_file" "private_key" {
  filename        = "dev-key"
  content         = tls_private_key.private_key.private_key_pem
  file_permission = "0400"
}


module "jenkins-master" {
  source = "./modules/server"

  sg-name = "jenkins-master-sg"
  sg-description = "Security group for jenkins master/slave"
  vpc-id = module.network.vpc-id
  inbound-rules = {
    ssh = {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    http = {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  outbound-rules = {
    all = {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  subnet-id = module.network.subnets-id[0]
  instance-type = "t2.medium"
  ami-type = "ubuntu"
  key-name = aws_key_pair.key_pair.key_name
  is-public = true
  user-data = ""
  instance-name = "jenkins-master"
}

module "jenkins-slave" {
  source = "./modules/server"

  sg-name = "jenkins-slave-sg"
  sg-description = "Security group for jenkins master/slave"
  vpc-id = module.network.vpc-id
  inbound-rules = {
    ssh = {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    http = {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  outbound-rules = {
    all = {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  subnet-id = module.network.subnets-id[1]
  instance-type = "t2.medium"
  ami-type = "ubuntu"
  key-name = aws_key_pair.key_pair.key_name
  is-public = true
  instance-name = "jenkins-slave"
}

module "sonarqube" {
  source = "./modules/server"

  sg-name = "sonarqube-sg"
  sg-description = "Security group for sonarQube"
  vpc-id = module.network.vpc-id
  inbound-rules = {
    ssh = {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    http = {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  outbound-rules = {
    all = {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  subnet-id = module.network.subnets-id[1]
  instance-type = "t2.medium"
  ami-type = "ubuntu"
  key-name = aws_key_pair.key_pair.key_name
  is-public = true
  instance-name = "sonarQube"
}