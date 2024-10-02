resource "random_shuffle" "az_selection" {
  input        = var.availability_zones
  result_count = 1  # Select one random availability zone
}

# Create Security Group for the Jump and Jenkins Servers
resource "aws_security_group" "mern_security_group" {
  vpc_id      = var.vpc_id  # Ensure you have the VPC defined in your module
  description = "Allowing Jenkins, Sonarqube, SSH Access"

  ingress = [
    for port in [22, 8080, 9000, 9090, 80, 443] : {
      description      = "Allow port ${port}"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mern-security-group"
  }
  # Ensure the VPC is created first
}

# Create Jump Server
resource "aws_instance" "jump_server" {
  ami                    = var.ami  # AMI ID for the Jump server
  instance_type         = var.instance_type  # Instance type for the Jump server
  subnet_id             = var.public_subnet_ids[0]  # Public subnet for the Jump server
  vpc_security_group_ids = [aws_security_group.mern_security_group.id]  # Use the created security group
  key_name              = var.key_name  # Key pair for SSH access

  availability_zone     = random_shuffle.az_selection.result[0]  # Randomly selected availability zone

  tags = {
    Name = "Jump Server"
  }

  user_data = file("${path.module}/jenkins-tools-install.sh")
  depends_on = [aws_security_group.mern_security_group]  # Ensure the security group is created first

}

# Create Jenkins Server
resource "aws_instance" "jenkins_server" {
  ami                    = var.ami  # AMI ID for the Jenkins server
  instance_type         = var.instance_type  # Instance type for the Jenkins server
  subnet_id             = var.public_subnet_ids[0]  # Public subnet for the Jenkins server
  vpc_security_group_ids = [aws_security_group.mern_security_group.id]  # Use the created security group
  key_name              = var.key_name  # Key pair for SSH access

  availability_zone     = random_shuffle.az_selection.result[0]  # Randomly selected availability zone

  tags = {
    Name = "Jenkins Server"
  }

  # Add user data
  user_data = file("/home/amr-kedra/MERN-Full-project/Terraform/modules/Jenkins-Jump-Servers/jenkins-tools-install.sh")
  depends_on = [aws_security_group.mern_security_group]  # Ensure the security group is created first

}
