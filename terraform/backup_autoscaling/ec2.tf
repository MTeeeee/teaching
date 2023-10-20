# # EC2 Instanz zum Testen des Setupt

# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
# resource "aws_instance" "test" {
#   count                  = length(var.public_subnets_cidr)
#   ami                    = "ami-0fb820135757d28fd"
#   instance_type          = "t2.micro"
#   subnet_id              = aws_subnet.subnet[count.index].id
#   vpc_security_group_ids = [aws_security_group.sg.id]
#   key_name               = "demo1"


#   tags = {
#     Name = "EC2 in az: ${var.availability_zones[count.index]}"
#   }

#   user_data = base64encode(templatefile("init.sh.tpl", {example = aws_vpc.main.id, subnet = aws_subnet.subnet[count.index].id}))
#   metadata_options {
#     http_endpoint               = "enabled"
#     http_put_response_hop_limit = 2
#     http_tokens                 = "optional"
#   }
# }
