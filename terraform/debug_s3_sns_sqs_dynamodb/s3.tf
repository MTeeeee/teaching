resource "aws_s3_bucket" "tf_s3" {
  bucket = var.s3_bucketname
  force_destroy = true
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.tf_s3.id

  depends_on = [aws_s3_bucket.tf_s3]

  topic {
    topic_arn     = aws_sns_topic.tf_sns_topic.arn
    events        = ["s3:ObjectCreated:*"]
  }
}
