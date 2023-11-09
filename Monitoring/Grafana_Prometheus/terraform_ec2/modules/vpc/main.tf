resource "aws_vpc" "my_vpc" {
  cidr_block           = var.cidr

  tags = {
      Name = var.name
  }
}
