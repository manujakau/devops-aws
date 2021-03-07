variable "profile" {}

variable "aws_region" {}

#------ storage variables

variable "s3_bucket_name" {}

#-------networking variables

variable "vpc_cidr" {}

variable "public_cidrs" {
  type = list(string)
}

variable "accessip" {}

variable "host_zone_name" {}

#-------compute variables

variable "key_name" {}

variable "instances_type01" {}

variable "instances_type02" {}