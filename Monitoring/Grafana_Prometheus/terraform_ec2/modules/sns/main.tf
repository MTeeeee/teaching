resource "aws_sns_topic" "prom_alerts" {
  name = "prom_alerts"
}

resource "aws_sns_topic_subscription" "prom_alerts_email_sub" {
  topic_arn = aws_sns_topic.prom_alerts.arn
  protocol  = "email"
  endpoint  = "<email>"
}