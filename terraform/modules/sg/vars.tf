variable "vpc_id" {
  description = "VPC ID where the security groups will be created"
  type        = string
}

variable "cluster_cidr_blocks" {
  description = "CIDR blocks allowed for EKS cluster"
  type        = list(string)
}

variable "worker_cidr_blocks" {
  description = "CIDR blocks allowed for EKS worker nodes"
  type        = list(string)
}
