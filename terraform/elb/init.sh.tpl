#!/bin/bash
set -x
sudo yum update -y
sudo yum install nginx -y
INSTANCE_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
echo "Hello from $INSTANCE_IP" > /usr/share/nginx/html/index.html
echo "VPC = ${example}" >> /usr/share/nginx/html/index.html
echo "Subnet = ${subnet}" >> /usr/share/nginx/html/index.html
sudo systemctl start nginx
sudo systemctl enable nginx