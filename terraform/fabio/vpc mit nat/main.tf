# Alle Locals werden innerhalb des locals Block definiert
locals {
  az_a = "${var.region}a" # eu-central-1a
  az_b = "${var.region}b"

  cidr_a = "10.0.1.0/24"
  cidr_b = "10.0.2.0/24"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "TF VPC"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "subnet_public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = local.cidr_b
  availability_zone = local.az_a
  map_public_ip_on_launch = true # Wir wollen, dass die Instanzen eine öffentliche IP bekommen

  tags = {
    Name = "TF Subnet Public"
  }
}

resource "aws_subnet" "subnet_private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = local.cidr_a
  availability_zone = local.az_a
  map_public_ip_on_launch = true # Wir wollen, dass die Instanzen eine öffentliche IP bekommen

  tags = {
    Name = "TF Subnet Private"
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
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0" # Das gesamte Internet
    gateway_id = aws_internet_gateway.gw.id # Link zu unserem erstellten Internet Gateway
  }

  tags = {
    Name = "TF Route Table Public"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "nat_eip" {}

resource "aws_nat_gateway" "deez_natg" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet_public.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.deez_natg.id
  }
  tags = {
    Name = "TF Route Table Private"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.subnet_private.id
  route_table_id = aws_route_table.private_rt.id
}

# -----------------------------------------------------------------------------------
# EC2 Instanz zum Testen des Setupt

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "sg" {
  name = "tf_sg"
  description = "Allow SSH inbound traffic"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "SSH from VPC"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "ec2_nat" {
  ami           = "ami-0fb820135757d28fd"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet_private.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name = "demo1"

  tags = {
    Name = "ec2_private"
  }
}
