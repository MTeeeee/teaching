output "ec2_ip" {
  description = "EC2 IP"
  value       = module.ec2_module.ec2_ip
}

output "sns_arn" {
  description = "SNS Topic ARN"
  value       = module.sns_module.sns_arn
}