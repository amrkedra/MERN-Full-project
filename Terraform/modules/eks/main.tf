# EKS Module

resource "aws_eks_cluster" "my_cluster" {
  name     = var.cluster_name
  role_arn = "arn:aws:iam::729207654069:role/EKS-Cluster-Admin"
  vpc_config {
    subnet_ids = var.private_subnet_ids
  }
}

resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = "my-eks-node-group"  # Keep the existing name
  node_role_arn   = "arn:aws:iam::729207654069:role/EKS-Cluster-Admin"
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  # Define tags dynamically for the node group
  tags = {
    Name        = "EKS-Node-${count.index + 1}"  # Dynamic naming
    Environment = var.env[0]                      # Assuming this is defined elsewhere
    Project     = "MyProject"
  }

  # Specify the number of instances you want (you might need to modify this part)
  # The instance count can be controlled through desired_size
  lifecycle {
    create_before_destroy = true  # Prevents issues during updates
  }

  # If you have more than one node group instance, consider managing them via count
  # This is an example; remove or adjust according to your needs
  count = var.node_count  # This variable should be defined in your variables.tf
}
