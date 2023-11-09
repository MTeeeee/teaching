output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.my_vpc.id
}

output "subnet_ids" {
  description = "The IDs of the subnets"
  value       = aws_subnet.my_subnet[*].id
}

# ... Other outputs like security group IDs, NAT gateways, etc.
