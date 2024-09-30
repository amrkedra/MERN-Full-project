variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_role_arn" {
  description = "ARN of the IAM role for the EKS cluster"
  type        = string
}

variable "node_role_arn" {
  description = "ARN of the IAM role for the EKS nodes"
  type        = string
}

variable "node_group_name" {
  description = "Name of the EKS node group"
  type        = string
}

variable "desired_size" {
  description = "Desired size of the EKS node group"
  type        = number
}

variable "max_size" {
  description = "Maximum size of the EKS node group"
  type        = number
}

variable "min_size" {
  description = "Minimum size of the EKS node group"
  type        = number
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the EKS nodes"
  type        = list(string)
}

variable "node_count" {
  description = "Number of EKS node group instances"
  type        = number
}

variable "env" {
  description = "The working environment (e.g., dev, prod)"
  type        = list(string)
}


variable "role_arn" {
  description = "The ARN for the cluster IAM role"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID for EKS"
  type        = string
}

variable "jump_server_private_ip" {
  description = "Private IP address of the jump server"
  type        = string
}
