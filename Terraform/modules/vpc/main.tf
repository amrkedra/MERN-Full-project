# Create VPC
resource "aws_vpc" "mern_app_vpc" {
  cidr_block = var.vpc_cidr
  
  tags = {
    Name = "MERN-VPC"
  }
}

# Public Subnets for Jenkins and Jump Server
resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet_cidrs)  # Dynamically based on CIDR blocks
  vpc_id                  = aws_vpc.mern_app_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet-${count.index == 0 ? "Jenkins" : "JumpServer"}"
  }
}

# Private Subnets for EKS Workers
resource "aws_subnet" "private_subnet" {
  count       = length(var.private_subnet_cidrs)  # Dynamically based on CIDR blocks
  vpc_id      = aws_vpc.mern_app_vpc.id
  cidr_block  = var.private_subnet_cidrs[count.index]

  tags = {
    Name = "EKSWorkerPrivateSubnet-${count.index + 1}"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.mern_app_vpc.id

  tags = {
    Name = "MERN-InternetGateway"
  }
}

# Create Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.mern_app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

# Associate Public Route Table with Public Subnets
resource "aws_route_table_association" "public_assoc" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public.id
}

# Create NAT Gateway in the first Public Subnet
resource "aws_eip" "nat_eip" {
  domain = "vpc"  # Use "vpc" to indicate this is for a VPC EIP

  tags = {
    Name = "MyNATGatewayEIP"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id  # Remove [0] since aws_eip.nat_eip is a single instance
  subnet_id     = aws_subnet.public_subnet[0].id  # Keep the index for the subnet as it uses count

  tags = {
    Name = "MERN-NATGateway"
  }
}

# Create Route Table for Private Subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.mern_app_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "PrivateRouteTable"
  }
}

# Associate Private Route Table with Private Subnets
resource "aws_route_table_association" "private_assoc" {
  count          = length(aws_subnet.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private.id
}


# Security Group for EKS Worker Nodes
resource "aws_security_group" "eks_worker_sg" {
  vpc_id      = aws_vpc.mern_app_vpc.id
  description = "Security Group for EKS Worker Nodes"

  # Allow EKS control plane traffic (default control plane communication)
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress: Allow nodes to connect via the NAT Gateway for external communication if necessary
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EKSWorkerNodesSG"
  }
}
