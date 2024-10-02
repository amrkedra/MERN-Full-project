
# VPC Variables
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "nat_gateway_subnet" {
  description = "Subnet ID for NAT Gateway"
  type        = string
}

variable "tags" {
  description = "Tags for all resources"
  type        = map(string)
}