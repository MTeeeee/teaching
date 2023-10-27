# Create a lambda function
# In terraform ${path.module} is the current directory.
resource "aws_lambda_function" "terraform_lambda_func" {
 filename                       = "${path.module}/python/sns_sqs_lambda.zip"
 function_name                  = "sns_sqs_lambda"
 role                           = aws_iam_role.lambda_role.arn
 handler                        = "sns_sqs_lambda.lambda_handler"
 runtime                        = "python3.11"

   environment {
    variables = {
      DYNAMODB_TABLE_NAME = var.dynamodb_table_name
    }
}
}

# Generates an archive from content, a file, or a directory of files.
data "archive_file" "zip_the_python_code" {
 type        = "zip"
 source_dir  = "${path.module}/python/"
 output_path = "${path.module}/python/sns_sqs_lambda.zip"
}


resource "aws_lambda_event_source_mapping" "example" {
  event_source_arn  = aws_dynamodb_table.input.stream_arn
  function_name     = aws_lambda_function.terraform_lambda_func.arn
  starting_position = "LATEST"
}


