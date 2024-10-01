
  resource "aws_vpc" "eks_vpc" {
  cidr_block = var.cidr_block

  tags = {
    Name = "EKS-VPC"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnets)  # Assuming var.private_subnets is a list of CIDR blocks

  vpc_id     = aws_vpc.eks_vpc.id
  cidr_block = var.private_subnets[count.index]
  map_public_ip_on_launch = false  # No public IP for private subnets
  availability_zone = element(data.aws_availability_zones.available.names, count.index)  # Use AZs from the data source

  tags = {
    Name = "PrivateSubnet-${count.index + 1}"
  }

  depends_on = [aws_vpc.eks_vpc]  # Ensure VPC is created first
}



resource "aws_subnet" "public_subnets" {
  count = 1
  vpc_id     = aws_vpc.eks_vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet-${count.index}"
  }
  depends_on = [aws_vpc.eks_vpc]  # Ensure VPC is created first
}

# Create an Internet Gateway for public subnet access
resource "aws_internet_gateway" "eks_ig" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "EKS-Internet-Gateway"
  }
  depends_on = [aws_vpc.eks_vpc]  # Ensure VPC is created first
}

# Attach the Internet Gateway to the public subnet route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_ig.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
  depends_on = [aws_vpc.eks_vpc]  # Ensure VPC is created first
}

