# Praxis: Terraform VPC

Nun wollen wir die EC2 Instanzen nicht mehr manuell anlegen. Sie sollen über eine Autoscaling Group nach definiertem Bedarf zu oder abgeschaltet werden.

## 0. Auskommentieren der nicht mehr gebrauchten Inhalte

1. Erstelle eine Kopie des `elb` Ordners und nenne Ihn autoscaling

2. Entferne die `ec2.tf`

3. Entferne die ressource `"aws_lb_target_group_attachment"` aus der `loadbalancer.tf`

## 1. Autoscaling

1. Erstelle eine neue datei mit dem Namen `autoscaling_group.tf`

2. Erstelle eine ressource `"aws_launch_template"` mit folgendem code und füge deinen eigenen key ein:

```terraform
resource "aws_launch_template" "launch_nginx" {
  image_id      = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.asg_sg.id]

  user_data = filebase64("init.sh.tpl")
  key_name = "demo1" # !!! eigenen key einfügen, muss unter Umständen noch erstellt werden !!!

}
```

3. Erstelle eine resource `"aws_autoscaling_group"` mit folgendem code:

```terraform
resource "aws_autoscaling_group" "asg" {
  # availability_zones = var.availability_zones
  max_size           = 3
  min_size           = 2

  vpc_zone_identifier = [for subnet in aws_subnet.subnet : subnet.id]

  launch_template {
    id      = aws_launch_template.launch_nginx.id
    version = "$Latest"
  }
}
```

4. Erstelle eine resource `"aws_autoscaling_attachment"` mit folgendem code:

```terraform
resource "aws_autoscaling_attachment" "asg_alb_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  lb_target_group_arn    = aws_lb_target_group.targetgroup.arn
}
```

5. (optional)
Teste gerne deinen code an dieser Stelle um fehlende anpassungen in den anderen Dateien auszubessern.
Es kann sein das noch Veränderungen den Dateien notwendig sind, welche hier noch nicht aufgeführt sind.
Die ressourcen sollten erstellt werden und die gewünschte anzahl an EC2 instanzen gestartet.

6. Erstelle eine resource `"aws_autoscaling_policy"` mit folgendem code:

```terraform
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.asg.name
}
```
7. Erstelle eine resource `"aws_autoscaling_policy"` mit folgendem code:

```terraform
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale_down"
  scaling_adjustment     = "-1"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.asg.name
}
```

8. Erstelle einen `"aws_cloudwatch_metric_alarm"` für das Überschreiten der CPU Auslastung.

```terraform
resource "aws_cloudwatch_metric_alarm" "ec2_over_50" {
  alarm_name          = "ec2_cpu_utilization_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.scale_up.arn]
}
```

9. Erstelle einen `"aws_cloudwatch_metric_alarm"` für das Überschreiten der CPU Auslastung.

```terraform
resource "aws_cloudwatch_metric_alarm" "ec2_under_50" {
  alarm_name          = "ec2_cpu_utilization_low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 20

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.scale_down.arn]
}
```



## 2. Testen


Verändere das startscript in der `init.sh.tpl` so, das die Maschienen einen Stresstest starten 

```bash
sudo dnf install stress -y
sudo stress --cpu 8 --timeout 800 & top
```

Die Datei sollte nun so aussehen:

```bash
#!/bin/bash
set -x
sudo yum update -y
sudo yum install nginx -y
echo "Hello from Terraform :)" > /usr/share/nginx/html/index.html
sudo systemctl start nginx
sudo systemctl enable nginx

sudo dnf install stress -y
sudo stress --cpu 8 --timeout 800 & top
```

## 3. Ausführen

Gehe die Befehle durch <br>

`terraform init` (falls dieser noch nicht eingegeben wurde) <br>
`terraform validate` <br>
`terraform plan` <br>
`terraform apply` <br>

Schaue in die EC2 Instanzen, es sollten nach und nach Maschinen hochgefahren werden bis zur gewünschten maximalen Anzahl.

Wenn alles funktioniert, beende die Übung mit:

`terraform destroy`
