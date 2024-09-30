# Jump Server Module
# Security Group for Jump Server allowing SSH access
resource "aws_security_group" "jump_server_sg" {
  vpc_id = var.vpc_id  # Pass the VPC ID

  # Inbound SSH access from a specific IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # IP or range allowed for SSH (e.g., your home/office IP)
    description = "Allow SSH from allowed IP"
  }

  # Outbound rules to allow all traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "JumpServerSG"
  }
  depends_on = [aws_vpc.eks_vpc]  # Ensure VPC is created first
}

resource "aws_instance" "jump_server" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnets[0].id  # Use subnet ID passed from the root module

  # Security Group for SSH
  vpc_security_group_ids = [aws_security_group.jump_server_sg.id]

  tags = {
    Name = "Jump-Server"
  }
  depends_on = [aws_vpc.eks_vpc]  # Ensure VPC is created first
}

