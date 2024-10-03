locals {

}
# module "aws-instances" {
#   source                      = "./modules/aws-instances"
#   ami                         = var.ami
#   instance_type               = var.instance_type # Corrected spelling from instatnce_type
#   key_name                    = var.key_name
#   subnet_id                   = var.subnet_id
#   instance_count              = var.instance_count # Assuming cou_inst is the correct variable name
#   env                         = var.env
#   associate_public_ip_address = "false"
#   names                       = var.names
#   aws_Region                  = var.aws_Region
#   cidr_block                  = var.cidr_block
#   availability_zone           = var.availability_zone
#   private_key_path            = var.private_key_path
# }




# VPC Module
module "vpc" {
  source               = "./modules/vpc"          # Update this with the actual path to your VPC module
  vpc_cidr             = var.vpc_cidr             # The VPC CIDR block
  public_subnet_cidrs  = var.public_subnet_cidrs  # List of CIDR blocks for public subnets
  private_subnet_cidrs = var.private_subnet_cidrs # List of CIDR blocks for private subnets
  nat_gateway_subnet   = var.nat_gateway_subnet   # Subnet ID for NAT Gateway
  tags                 = var.tags                 # Tags for resources
}




module "ecr" {
  source               = "./modules/ecr"
  repository_name      = var.repository_name
  image_tag_mutability = var.image_tag_mutability
  env                  = var.env

}

# # Security Group Module
# module "security_group" {
#   source               = "./modules/sg"
#   vpc_id              = module.vpc.vpc.id
#   cluster_cidr_blocks = var.cluster_cidr_blocks # Adjust as needed
#   worker_cidr_blocks  = var.worker_cidr_blocks # Adjust as needed
# }

# EKS Module

module "Jenkins-Jump-Servers" {
  source                      = "./modules/Jenkins-Jump-Servers" # Ensure the source path is correct
  ami                         = var.ami                          # Specify the AMI ID for the jump server
  instance_type               = var.instance_type                # Instance type for the jump server
  key_name                    = var.key_name                     # SSH key for accessing the jump server
  vpc_id                      = module.vpc.vpc_id
  associate_public_ip_address = var.associate_public_ip_address
  region                      = var.region
  availability_zones          = var.availability_zones
  private_key_path            = var.private_key_path
  vpc_cidr                    = var.vpc_cidr
  env                         = var.env
  public_subnet_ids           = module.vpc.public_subnet_ids
  

}
output "jump_server_ip" {
  value = module.Jenkins-Jump-Servers.jump_server_ip # Access the jump server IP from the module output
}

module "eks" {
  source             = "./modules/eks" # Path to your EKS module
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  node_group_name    = "my-node-group" # Replace with your desired node group name
  desired_capacity   = var.desired_capacity                                 # Number of desired nodes
  max_capacity       = var.max_capacity                                 # Maximum number of nodes
  min_capacity       = var.min_capacity                                 # Minimum number of nodes
  region             = var.region     # Specify the region for the EKS cluster
  cluster_name       = var.cluster_name # Specify the name for the EKS cluster
  cidr_block         = var.vpc_cidr
}


output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_arn" {
  value = module.eks.cluster_arn
}

output "eks_node_group_name" {
  value = module.eks.node_group_name
}

output "eks_node_group_arn" {
  value = module.eks.node_group_arn
}

output "eks_node_group_id" {
  value = module.eks.node_group_id
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}


