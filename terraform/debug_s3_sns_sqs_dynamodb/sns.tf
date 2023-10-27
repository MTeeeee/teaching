resource "aws_sns_topic" "tf_sns_topic" {
  name = "tf_sns_topic"
  # policy = data.aws_iam_policy_document.topic.json
}

data "aws_iam_policy_document" "iam_sns_policy_document" {
  statement {
    effect = "Allow"
    actions   = ["SNS:Publish"]
    resources = [aws_sns_topic.tf_sns_topic.arn]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [aws_s3_bucket.tf_s3.arn]
    }
  }
}

resource "aws_sns_topic_policy" "s3_to_sns" {
  arn = aws_sns_topic.tf_sns_topic.arn
  policy = data.aws_iam_policy_document.iam_sns_policy_document.json
}

resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = aws_sns_topic.tf_sns_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.tf_sqs.arn
}