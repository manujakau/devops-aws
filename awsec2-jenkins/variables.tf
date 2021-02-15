variable "profile" {
  default = "manuja-cli"
}
variable "region" {
  default = "eu-central-1"
}
variable "vpc" {
  default = "vpc-1f39b977"
}
variable "subnet" {
  default = "subnet-b7edd7fd"
}
variable "instanceType" {
  default = "t2.micro"
}
variable "keyName" {
  default = "SAA-C01"
}
variable "instanceName" {
  default = "jenkins-host"
}
variable "amis" {
  type = map(string)
  default = {
    us-east-1    = "ami-047a51fa27710816e"
    eu-central-1 = "ami-0a6dc7529cd559185"
    eu-north-1   = "ami-0eb6f319b31f7092d"
  }
}
variable "volumeType" {
  default = "gp2"
}
variable "volumeSize" {
  default = 15
}