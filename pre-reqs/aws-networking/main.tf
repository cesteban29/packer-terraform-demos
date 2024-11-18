resource "aws_vpc" "demo_env" {
  cidr_block           = var.address_space
  enable_dns_hostnames = true

  tags = {
    name = "${var.prefix}-vpc-${var.region}"
    environment = "Demo"
  }
}

resource "aws_subnet" "demo_default_subnet" {
  vpc_id     = aws_vpc.demo_env.id
  cidr_block = var.subnet_prefix

  tags = {
    name = "${var.prefix}-public-subnet"
  }
}

resource "aws_security_group" "public_access_security_group" {
  name = "public-access-security-group"

  vpc_id = aws_vpc.demo_env.id

  ingress { # SSH access
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow all traffic from the public internet
  }

  ingress { # HTTP access
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow all traffic from the public internet
  }

  ingress { # HTTPS access
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow all traffic from the public internet
  }

  egress { # All traffic 
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"] # Allow all traffic to the public internet
    prefix_list_ids = []
  }

  tags = {
    Name = "public-access-security-group"
  }
}

resource "aws_internet_gateway" "demo_env_internet_gateway" {
  # Create an internet gateway for the VPC to use to get out to the public internet
  vpc_id = aws_vpc.demo_env.id

  tags = {
    Name = "${var.prefix}-internet-gateway"
  }
}

resource "aws_route_table" "public_route_table" {
  # Create a route table for the VPC to use to get out to the public internet
  vpc_id = aws_vpc.demo_env.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_env_internet_gateway.id
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  # Associate the route table with the subnet making it public
  subnet_id      = aws_subnet.demo_default_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}