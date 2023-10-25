resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "Messages"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "Id"

  attribute {
    name = "Id"
    type = "S"
  }

#   attribute {
#     name = "Message"
#     type = "S"
#   }

}

resource "aws_dynamodb_table_item" "example" {
  table_name = aws_dynamodb_table.basic-dynamodb-table.name
  hash_key   = aws_dynamodb_table.basic-dynamodb-table.hash_key

  item = jsonencode(
{
  "Id": {"S": "Hello"},
  "Message": {"S": "From Terraform"},
})
}