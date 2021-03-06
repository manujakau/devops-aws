
provider "aws" {
  profile = var.profile
  region  = var.aws_region
}

# Deploy Networking Resources
module "networking" {
  source       = "./networking"
  vpc_cidr     = var.vpc_cidr
  public_cidrs = var.public_cidrs
  accessip     = var.accessip
}

## Deploy Compute Resources
module "compute" {
  source         = "./compute"
  region         = var.aws_region
  key_name       = var.key_name
  instance_type  = var.instances_type01
  subnets        = module.networking.public_subnets
  security_group = module.networking.public_sg
  subnet_ips     = module.networking.subnet_ips
}

## deploy storage resource
#module "storage" {
#  source       = "./storage"
#  project_name = var.project_name
#}
#