resource "aws_dynamodb_table" "input" {
  name           = "Input"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "Id"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "Id"
    type = "S"
  }
}

resource "aws_dynamodb_table" "output" {
  name           = var.dynamodb_table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "Id"

  attribute {
    name = "Id"
    type = "S"
  }
}


# resource "aws_dynamodb_table_item" "example" {
#   table_name = aws_dynamodb_table.basic-dynamodb-table.name
#   hash_key   = aws_dynamodb_table.basic-dynamodb-table.hash_key

#   item = jsonencode(
# {
#   "Id": {"S": "Hello"},
#   "Message": {"S": "From Terraform"},
# })
# }