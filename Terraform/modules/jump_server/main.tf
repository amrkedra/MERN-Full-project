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
}

resource "aws_instance" "jump_server" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_ids[0]  # Use subnet ID passed from the root module

  # Security Group for SSH
  vpc_security_group_ids = [aws_security_group.jump_server_sg.id]

  tags = {
    Name = "Jump-Server"
  }
}

