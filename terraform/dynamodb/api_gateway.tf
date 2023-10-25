resource "aws_apigatewayv2_api" "hello-api" {
  name          = "example-http-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_route" "hello-route" {
  api_id    = aws_apigatewayv2_api.hello-api.id
  route_key = "POST /post"
  target    = "integrations/${aws_apigatewayv2_integration.hello-integration.id}"
}

resource "aws_apigatewayv2_integration" "hello-integration" {
  api_id           = aws_apigatewayv2_api.hello-api.id
  integration_type = "AWS_PROXY"

  integration_method = "POST"
  integration_uri    = aws_lambda_function.terraform_lambda_func.invoke_arn
}

resource "aws_apigatewayv2_stage" "example" {
  api_id      = aws_apigatewayv2_api.hello-api.id
  name        = "example-stage"
  auto_deploy = true
}
