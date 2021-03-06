#VPC
data "aws_availability_zones" "available" {}

resource "aws_vpc" "devops_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "devops-vpc"
  }
}

#internet gateway
resource "aws_internet_gateway" "devops_internet_gateway" {
  vpc_id = aws_vpc.devops_vpc.id

  tags = {
    Name = "devops_igw"
  }
}

#public route
resource "aws_route_table" "devops_public_rt" {
  vpc_id = aws_vpc.devops_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops_internet_gateway.id
  }

  tags = {
    Name = "devops_public"
  }
}

#private route
resource "aws_default_route_table" "devops_private_rt" {
  default_route_table_id = aws_vpc.devops_vpc.default_route_table_id

  tags = {
    Name = "devops_private"
  }
}

# subnets
resource "aws_subnet" "devops_public_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.devops_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "devops_public_${count.index + 1}"
  }
}

# subnet associations
resource "aws_route_table_association" "devops_public_assoc" {
  count          = length(var.public_cidrs)
  subnet_id      = element(aws_subnet.devops_public_subnet.*.id, count.index)
  route_table_id = aws_route_table.devops_public_rt.id
}

# security groups
resource "aws_security_group" "devops_public_sg" {
  name        = "devops_public_sg"
  description = "Used for access to the public instances"
  vpc_id      = aws_vpc.devops_vpc.id

  #SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.accessip]
  }

  #HTTP
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}