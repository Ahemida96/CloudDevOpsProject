data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Amazon
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical's AWS Account ID for official Ubuntu images
}

resource "aws_security_group" "this" {
  name = var.sg-name
  description = var.sg-description
  vpc_id = var.vpc-id

  dynamic "ingress" {
    for_each = var.inbound-rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.outbound-rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

locals {
  ami-id = var.ami-type == "ubuntu" ? data.aws_ami.ubuntu.id : data.aws_ami.amazon_linux.id
}

resource "aws_instance" "this" {
  ami                         = local.ami-id
  instance_type               = var.instance-type
  key_name                    = var.key-name
  subnet_id                   = var.subnet-id
  vpc_security_group_ids      = [ aws_security_group.this.id ]
  user_data                   = var.user-data
  associate_public_ip_address = var.is-public

  tags = {
    Name = var.instance-name
    Role = var.instance-role
  }

  provisioner "local-exec" {
		command = "echo ${self.public_ip} >> instances-ip.txt"
	}
}

