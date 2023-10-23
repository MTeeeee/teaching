# Praxis: Terraform VPC

Diese Woche wollen wir die gelernten Dinge der letzten Wochen zusammenführen in einem Miniprojekt

## 0. Erstelle einen neuen Ordner für das Projekt

1. Erstelle eine `main.tf`

2. Füge den provider ein:

```terraform 
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
```

3. Erstelle die Dateien `variables.tf` und `vars.auto.tfvars`

4. Schriebe die definition für dein das aws Profil und die Region in die `variables.tf`

```terraform
variable "region" {
  type = string # Welcher Datentyp ist die Variable?
  default = "eu-central-1" # Welchen Wert hat die Variable, wenn nichts angegeben wird?
}

# userprofile variable
variable "aws_profile" {
  type = string # Welcher Datentyp ist die Variable?
}
```
5. Befülle die `vars.auto.tfvars` mit den nötigen Daten:

```terraform 
aws_profile = "<dein profil>"

region = "eu-central-1"

```

## 1. S3 Bucket

1. Erstelle eine neue datei mit dem Namen `s3.tf`

2. Erstelle die Resource S3 Bucket:

```terraform
resource "aws_s3_bucket" "example" {
  bucket = "hello-s3-20231022"
}
```

## 2. Berechtigungen

1. Erstelle eine Datei namens `iam_roles.tf`

2. Erstelle eine ressource `"aws_iam_role"`:

```terraform
resource "aws_iam_role" "lambda_role" {
 name   = "terraform_aws_lambda_role"
 assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}
```

3. Erstelle eine ressource `"aws_iam_policy"`:

```terraform
resource "aws_iam_policy" "iam_policy_for_lambda" {

  name         = "aws_iam_policy_for_terraform_aws_lambda_role"
  path         = "/"
  description  = "AWS IAM Policy for managing aws lambda role"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}
```
4. Erstelle eine ressource `"aws_iam_policy"`:

```terraform
resource "aws_iam_policy" "iam_policy_for_lambda2" {

  name         = "aws_iam_policy_for_terraform_aws_lambda_role2"
  path         = "/"
  description  = "AWS IAM Policy for managing aws lambda role"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::hello-s3-20231022/*"
        }
    ]
}
EOF
}
```

5. Erstelle eine resource `aws_iam_role_policy_attachment`:

```terraform
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role        = aws_iam_role.lambda_role.name
  policy_arn  = aws_iam_policy.iam_policy_for_lambda.arn
}
```

6. Erstelle eine resource `aws_iam_role_policy_attachment`:

```terraform
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role2" {
  role        = aws_iam_role.lambda_role.name
  policy_arn  = aws_iam_policy.iam_policy_for_lambda2.arn
}
```

## 3. Lambda Function

1. Erstelle einen Unterordner namens python mit einer `lambda.py` datei.

2. Schriebe deinen Code für die Lambdafuktion in die Datei:

```python
import json
import boto3
import uuid

def lambda_handler(event, context):
    # TODO implement
    message = event["body"]
    
    s3 = boto3.client('s3')
    bucket_name = 'hello-s3-20231022'
    file_name = str(uuid.uuid4()) + '.txt'
    file_content = message
    
    response = s3.put_object(
    Body=file_content,
    Bucket=bucket_name,
    Key=file_name,
    )
    
    return {
        'statusCode': 200,
        'body': json.dumps('Your Data has been saved to'+file_name)
    }
```

3. Erstelle eine Datei `lambda.tf`

4. Erstelle eine resource `"aws_lambda_function"`:

```terraform
resource "aws_lambda_function" "terraform_lambda_func" {
 filename                       = "${path.module}/python/hello-python.zip"
 function_name                  = "hello-post"
 role                           = aws_iam_role.lambda_role.arn
 handler                        = "hello-post.lambda_handler"
 runtime                        = "python3.11"
}
```

5. Erstelle eine resource `archive_file`:

```terraform
data "archive_file" "zip_the_python_code" {
 type        = "zip"
 source_dir  = "${path.module}/python/"
 output_path = "${path.module}/python/hello-python.zip"
}
```

## 4. API Gateway

1. Erstelle eine Datei namens `api_gateway.tf`

2. Erstelle eine resource `aws_apigatewayv2_api`:

```terraform
resource "aws_apigatewayv2_api" "hello-api" {
  name          = "example-http-api"
  protocol_type = "HTTP"
}
```

3. Erstelle eine resource `aws_apigatewayv2_stage`:

```terraform
resource "aws_apigatewayv2_stage" "example" {
  api_id      = aws_apigatewayv2_api.hello-api.id
  name        = "example-stage"
  auto_deploy = true
}
```

4. Erstelle eine resource `aws_apigatewayv2_route`:

```terraform
resource "aws_apigatewayv2_route" "hello-route" {
  api_id    = aws_apigatewayv2_api.hello-api.id
  route_key = "POST /post"
  target    = "integrations/${aws_apigatewayv2_integration.hello-integration.id}"
}
```

5. Erstelle eine resource `aws_apigatewayv2_integration`:

```terraform
resource "aws_apigatewayv2_integration" "hello-integration" {
  api_id           = aws_apigatewayv2_api.hello-api.id
  integration_type = "AWS_PROXY"

  integration_method = "POST"
  integration_uri    = aws_lambda_function.terraform_lambda_func.invoke_arn
}
```

6. In der Datei `lambda.tf` erstelle eine resource `aws_lambda_permission`:

```terraform
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.terraform_lambda_func.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.hello-api.execution_arn}/*/*/post"
}
```

## 5. Terraform

1. terraform init
2. terraform validate
3. terraform plan
4. terraform apply

5. terraform destroy


