terraform {
  required_version = ">= 1.0" # Wir wollen mindestens terraform version 1.0 verwenden

  required_providers {
    aws = {  # Der AWS Provider ermöglicht es AWS Resourcen zu erstellen
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region # Diese Terraform variable definieren wir im nächsten Schritt
  profile = var.aws_profile # Diese Terraform variable definieren wir im nächsten Schritt
}







# output "teraform_aws_role_output" {
#  value = aws_iam_role.lambda_role.name
# }

# output "teraform_aws_role_arn_output" {
#  value = aws_iam_role.lambda_role.arn
# }

# output "teraform_logging_arn_output" {
#  value = aws_iam_policy.iam_policy_for_lambda.arn
# }