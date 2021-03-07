variable "region" {}

variable "key_name" {}

variable "subnet_ips" {
  type = list(string)
}

variable "instance_type" {}

variable "instance_type_kube" {}

variable "security_group" {}

variable "security_group_kube" {}

variable "subnets" {
  type = list(string)
}