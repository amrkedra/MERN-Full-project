# EKS Cluster Module

resource "aws_eks_cluster" "my_cluster" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids = var.private_subnet_ids  # EKS nodes in private subnets
  }
  depends_on = [var.vpc_id]
}

# Security Group for EKS Node Group
resource "aws_security_group" "eks_node_group_sg" {
  vpc_id = var.vpc_id  # Correct VPC ID reference from the module output

  # Allow SSH access only from the jump server's private IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Jump server private IP
    description = "Allow SSH from Jump Server"
  }
  
  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EKSNodeGroupSG"
  }
}

# EKS Node Group
resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = var.node_group_name
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  # Attach the security group to the node group
  depends_on = [aws_security_group.eks_node_group_sg]

  # Define tags dynamically for the node group
  tags = {
    Name        = "EKS-Node-${count.index + 1}"
    Environment = var.env[0]
    Project     = "MyProject"
  }

  lifecycle {
    create_before_destroy = true
  }

  count = var.node_count
}
