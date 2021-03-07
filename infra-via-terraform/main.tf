
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
  host_zone    = var.host_zone_name
}

## Deploy Compute Resources
module "compute" {
  source              = "./compute"
  region              = var.aws_region
  key_name            = var.key_name
  instance_type       = var.instances_type01
  instance_type_kube  = var.instances_type02
  subnets             = module.networking.public_subnets
  security_group      = module.networking.public_sg
  security_group_kube = module.networking.public_k8s_sg
  subnet_ips          = module.networking.subnet_ips
}

# deploy storage resource
module "storage" {
  source         = "./storage"
  s3_bucket_name = var.s3_bucket_name
}