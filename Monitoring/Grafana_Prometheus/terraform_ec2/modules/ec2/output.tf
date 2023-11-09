output "ec2_ip" {
  description = "EC2 IP"
  value       = aws_instance.test.*.public_ip
}