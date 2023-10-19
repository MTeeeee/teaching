output "loadbalancer_url" {
  value = aws_lb.application_loadbalancer.dns_name
}

# output "subnet" {
#   value = aws_subnet.subnet
# }