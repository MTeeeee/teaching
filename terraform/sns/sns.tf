resource "aws_sns_topic" "yummy_dummy" {
  name = "yummy_dummy"
}

resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = aws_sns_topic.yummy_dummy.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.terraform_lambda_func.arn
}