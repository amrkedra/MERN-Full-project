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


module "ecr" {
  source               = "./modules/ecr"
  repository_name      = var.repository_name
  image_tag_mutability = var.image_tag_mutability
  aws_Region           = var.aws_Region
  env                  = var.env

}

# VPC Module
module "vpc" {
  source                  = "./modules/vpc"
  vpc_cidr                = var.vpc_cidr
  private_subnet_a_cidr   = var.private_subnet_a_cidr
  private_subnet_b_cidr   = var.private_subnet_b_cidr
  public_subnet_cidr      = var.public_subnet_cidr
  availability_zone_a     = var.availability_zone_a
  availability_zone_b     = var.availability_zone_b
  availability_zone_c     = var.availability_zone_c
}

# Security Group Module
module "security_group" {
  source               = "./modules/sg"
  vpc_id              = module.vpc.vpc_id
  cluster_cidr_blocks = var.cluster_cidr_blocks # Adjust as needed
  worker_cidr_blocks  = var.worker_cidr_blocks # Adjust as needed
}

# EKS Module
module "eks" {
  source           = "./modules/eks"
  cluster_name     = var.cluster_name
  cluster_role_arn = var.cluster_role_arn # Replace with your IAM role ARN
  node_role_arn    = var.node_role_arn    # Replace with your IAM role ARN
  node_group_name  = var.node_group_name
  desired_size     = var.desired_size
  max_size         = var.max_size
  min_size         = var.min_size
  private_subnet_ids = module.vpc.private_subnet_ids
}