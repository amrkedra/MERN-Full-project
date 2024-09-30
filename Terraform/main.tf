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
  source                = "./modules/vpc"
  vpc_cidr              = var.vpc_cidr                       # CIDR block for the VPC
  private_subnet_a_cidr = var.private_subnet_a_cidr          # CIDR block for private subnet A
  private_subnet_b_cidr = var.private_subnet_b_cidr          # CIDR block for private subnet B
  public_subnet_cidr    = var.public_subnet_cidr             # CIDR block for public subnet

  availability_zone_a   = var.availability_zone_a            # Availability zone for private subnet A
  availability_zone_b   = var.availability_zone_b            # Availability zone for private subnet B
  availability_zone_c   = var.availability_zone_c            # Availability zone for public subnet
  private_subnet_ids    = var.private_subnet_ids             # List of private subnet IDs for EKS nodes
  vpc_id                = var.vpc_id                         # VPC ID for EKS
  cidr_block            = var.cidr_block                     # The CIDR block for the VPC
  private_subnets       = var.private_subnets                # List of private subnet CIDR blocks
}





module "ecr" {
  source               = "./modules/ecr"
  repository_name      = var.repository_name
  image_tag_mutability = var.image_tag_mutability
  aws_Region           = var.aws_Region
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

module "jump_server" {
  source = "./modules/jump_server"  # Ensure the source path is correct
  ami             = var.ami             # Specify the AMI ID for the jump server
  instance_type   = var.instance_type         # Instance type for the jump server
  key_name        = var.key_name              # SSH key for accessing the jump server
  vpc_id          = module.vpc.vpc_id   
  associate_public_ip_address = var.associate_public_ip_address
  cidr_block      = var.cidr_block
  aws_Region      = var.aws_Region
  availability_zone = var.availability_zone
  private_key_path = var.private_key_path
  vpc_cidr = var.vpc_cidr  
  env             = var.env 
  public_subnet_ids = module.vpc.public_subnet_ids

}
output "jump_server_ip" {
  value = module.jump_server.jump_server_ip  # Access the jump server IP from the module output
}

module "eks" {
  source             = "./modules/eks"
  
  # EKS Cluster Configuration
  cluster_name       = var.cluster_name                      # Name of the EKS cluster
  cluster_role_arn   = var.cluster_role_arn                  # ARN of the IAM role for the EKS cluster
  node_role_arn      = var.node_role_arn                     # ARN of the IAM role for the EKS nodes
  node_group_name    = var.node_group_name                   # Name of the EKS node group
  desired_size       = var.desired_size                      # Desired size of the EKS node group
  max_size           = var.max_size                          # Maximum size of the EKS node group
  min_size           = var.min_size                          # Minimum size of the EKS node group
  role_arn           = var.cluster_role_arn 
  private_subnet_ids = module.vpc.private_subnet_ids          # List of private subnet IDs from the VPC module
  vpc_id             = module.vpc.vpc_id               
  node_count         = var.node_count                        # Number of EKS node group instance
  env                = var.env   
  jump_server_private_ip     = module.jump_server.jump_server_private_ip
}
