# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template
resource "aws_launch_template" "launch_nginx" {
  image_id      = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.asg_sg.id]

  user_data = filebase64("init.sh.tpl")
  key_name = "demo1"

}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group
resource "aws_autoscaling_group" "asg" {
  # availability_zones = var.availability_zones
  desired_capacity   = 3
  max_size           = 5
  min_size           = 2

  vpc_zone_identifier = [for subnet in aws_subnet.subnet : subnet.id]

  launch_template {
    id      = aws_launch_template.launch_nginx.id
    version = "$Latest"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment
resource "aws_autoscaling_attachment" "asg_alb_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  lb_target_group_arn    = aws_lb_target_group.targetgroup.arn
}