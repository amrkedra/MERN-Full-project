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

  ingress = [
    for port in [22, 10255, 443, 10250] : {
      description      = "TLS from VPC"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      ipv6_cidr_blocks = ["::/0"]
      self             = false
      prefix_list_ids  = []
      security_groups  = []
      cidr_blocks      = ["0.0.0.0/0"]
    }
  ]

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

# IAM Role for EKS Worker Nodes
resource "aws_iam_role" "eks_worker_role" {
  name               = "eks_worker_role"
  assume_role_policy = data.aws_iam_policy_document.eks_worker_assume_role_policy.json
}

# Assume Role Policy Document for Worker Role
data "aws_iam_policy_document" "eks_worker_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Attach the required IAM policies to the worker role
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_worker_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_worker_role.name
}

resource "aws_iam_role_policy_attachment" "eks_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_worker_role.name
}

# EKS Node Group
resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks_worker_role.arn  # Reference to the newly created IAM role
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
