output "instance_id_a" {
  value = aws_instance.ec2_nat.public_ip
}
