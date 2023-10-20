# Praxis: Terraform VPC

Nun wollen wir die EC2 instanzen nicht mehr manuell anlegen, sondern das eine autoscaling Funktion haben und nach Bedarf zu oder abgeschaltet werden.

## 0. Auskommentieren der nicht mehr gebrauchten Inhalte

1. Erstelle eine Kopie des `elb` ordners und nenne Ihn autoscaling

2. Entferne die `ec2.tf`

3. Entferne die ressource `"aws_lb_target_group_attachment"` aus der `loadbalancer.tf`

## 1. Autoscaling

1. Erstelle eine neue datei mit dem Namen `autoscaling_group.tf`

2. Erstelle ein Template 

```terraform
resource "aws_launch_template" "launch_nginx" {
  image_id      = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.asg_sg.id]

  user_data = filebase64("init.sh.tpl")
  key_name = "demo1" # einenen key einfügen

}
```

3. Erstelle eine autoscaling gruppe

```terraform
resource "aws_autoscaling_group" "asg" {
  # availability_zones = var.availability_zones
  desired_capacity   = 2
  max_size           = 3
  min_size           = 2

  vpc_zone_identifier = [for subnet in aws_subnet.subnet : subnet.id]

  launch_template {
    id      = aws_launch_template.launch_nginx.id
    version = "$Latest"
  }
}
```

4. Erstelle eine autoscaling attachement

```terraform
resource "aws_autoscaling_attachment" "asg_alb_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  lb_target_group_arn    = aws_lb_target_group.targetgroup.arn
}
```





ressources 
    - aws_autoscaling_group
        - lanch template?
    - aws_autoscaling_policy +
    - aws_autoscaling_policy -
    - aws_cloudwatch_metric_alarm +
    - aws_cloudwatch_metric_alarm -

