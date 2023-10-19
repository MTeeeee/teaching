# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"                # Das gesamte Internet
    gateway_id = aws_internet_gateway.gw.id # Link zu unserem erstellten Internet Gateway
  }

  tags = {
    Name = "TF Route Table"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "subnet_route" {
  count     = length(var.public_subnets_cidr)
  subnet_id = aws_subnet.subnet[count.index].id
  # subnet_id      = element(aws_subnet.subnet.*.id, count.index) # es kann auch mal so geschrieben gefunden werden
  route_table_id = aws_route_table.rt.id
}