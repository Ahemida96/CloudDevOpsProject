variable "sg-name" {
  type = string
  description = "Security group name"
}

variable "sg-description" {
  type = string
  description = "Description of security group"
}

variable "vpc-id" {
  type = string
  description = "VPC id for security group"
}

variable "inbound-rules" {
  type = map(object({
    from_port = number
    to_port = number
    protocol = string
    cidr_blocks = list(string)
  }))
  description = "The inbound rules for the security group in format of a map of objects with keys from_port, to_port, protocol, and cidr_blocks"
}

variable "outbound-rules" {
  type = map(object({
    from_port = number
    to_port = number
    protocol = string
    cidr_blocks = list(string)
  }))
  description = "The outbound rules for the security group in format of a map of objects with keys from_port, to_port, protocol, and cidr_blocks"
}

variable "subnet-id" {
  description = "The ID of the subnet to launch the EC2 instance in"
  type        = string
}

variable "instance-type" {
  description = "The type of EC2 instance to launch"
  type        = string
  default     = "t2.micro"
}

variable "ami-type" {
  description = "The AMI Type to use for the EC2 instance"
  type        = string
}

variable "key-name" {
  description = "The name of the EC2 key pair to use"
  type        = string
}

variable "user-data" {
  description = "The user data to provide when launching the EC2 instance"
  type        = string
  default     = null
}

variable "instance-name" {
  description = "A list of name to assign to the instances"
  type        = string
}

variable "is-public" {
  description = "Associate a public IP address with the instance"
  type        = bool
  default     = false
}