resource "aws_dynamodb_table" "basic-dynamodb-table" {
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