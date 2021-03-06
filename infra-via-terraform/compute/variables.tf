variable "region" {}

variable "key_name" {}

variable "subnet_ips" {
  type = list(string)
}

variable "instance_type" {}

variable "security_group" {}

variable "subnets" {
  type = list(string)
}