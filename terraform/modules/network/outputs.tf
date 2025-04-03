output "vpc-id" {
  value = aws_vpc.this.id
}

output "subnets-id" {
  value = aws_subnet.this[*].id
}