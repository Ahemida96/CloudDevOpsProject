resource "aws_vpc" "this" {
  cidr_block = var.vpc-cidr-block

  tags = {
    Name = var.vpc-name
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "igw"
  }
}

resource "aws_subnet" "this" {
  count = length(var.subnets-cidr-block)

  vpc_id = aws_vpc.this.id
  cidr_block = var.subnets-cidr-block[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = var.public-subnet[count.index]

  tags = {
    Name = var.subnets-name[count.index]
  }
}

resource "aws_route_table" "this" {
  count = length(var.subnets-cidr-block)
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.subnets-name[count.index]} Route Table"
  }
}

resource "aws_route_table_association" "this" {
  count = length(var.subnets-cidr-block)

  subnet_id = aws_subnet.this[count.index].id
  route_table_id = aws_route_table.this[count.index].id
}
