variable "profile" {}

variable "aws_region" {}

#------ storage variables

variable "project_name" {}

#-------networking variables

variable "vpc_cidr" {}

variable "public_cidrs" {
  type = list(string)
}

variable "accessip" {}

#-------compute variables

variable "key_name" {}

variable "instances_type01" {}

variable "amazon_ami" {
  type = map(string)
}