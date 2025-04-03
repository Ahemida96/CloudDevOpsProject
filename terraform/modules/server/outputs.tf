output "instance_id" {
  description = "The ID of the instance"
  value = try(
    aws_instance.this.id,
    null,
  )
}

output "private_ip" {
  description = "The private IP address assigned to the instance"
  value = try(aws_instance.this.private_ip,
    null,
  )

}

output "public_ip" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use the public_ip"
  value = try(
    aws_instance.this.public_ip,
    null,
  )

}