# Alle Locals werden innerhalb des locals Block definiert
locals {
  availibility_zones = ["${var.region}a", "${var.region}b", "${var.region}c"] # eu-central-1a
  cidr_subnets       = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "TF VPC"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "subnet" {
  count                   = length(local.cidr_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.cidr_subnets[count.index]
  availability_zone       = local.availibility_zones[count.index]
  map_public_ip_on_launch = true # Wir wollen, dass die Instanzen eine öffentliche IP bekommen

  tags = {
    Name = "TF Subnet ${local.availibility_zones[count.index]}"
  }
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "TF Internet Gateway"
  }
}

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
  count          = length(local.cidr_subnets)
  subnet_id      = aws_subnet.subnet[count.index].id
  # subnet_id      = element(aws_subnet.subnet.*.id, count.index) # es kann auch mal so geschrieben gefunden werden
  route_table_id = aws_route_table.rt.id
}


# -----------------------------------------------------------------------------------
# EC2 Instanz zum Testen des Setupt

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "sg" {
  name        = "tf_sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "test" {
  count = length(local.cidr_subnets)
  ami                    = "ami-0fb820135757d28fd"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet[count.index].id
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = "EC2 in az: ${local.availibility_zones[count.index]}"
  }
}
