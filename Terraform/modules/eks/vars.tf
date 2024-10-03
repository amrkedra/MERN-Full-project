variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the EKS cluster will be deployed"
  type        = string
}


variable "node_group_name" {
  description = "The name of the EKS node group"
  type        = string
}

variable "desired_capacity" {
  description = "Desired number of EC2 instances in the node group"
  type        = number
  
}

variable "max_capacity" {
  description = "Maximum number of EC2 instances in the node group"
  type        = number
  
}

variable "min_capacity" {
  description = "Minimum number of EC2 instances in the node group"
  type        = number
  
}

variable "region" {
  description = "The AWS region to deploy the EKS cluster"
  type        = string
}


variable "private_subnet_ids" {
  description = "A list of private subnet IDs for the EKS worker nodes"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "A list of public subnet IDs for the EKS worker nodes"
  type        = list(string)
}
variable "cidr_block" {
  type = string
  description = "the VPC CIDR Block"
}


