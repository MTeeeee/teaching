#!/bin/bash
set -x
sudo yum update -y
sudo yum install nginx -y
echo "Hello from Terraform :)" > /usr/share/nginx/html/index.html
sudo systemctl start nginx
sudo systemctl enable nginx

sudo dnf install stress -y
sudo stress --cpu 8 --timeout 800 & top