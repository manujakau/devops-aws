profile = "default"

aws_region = "eu-north-1"

project_name = "devops-aws"

vpc_cidr = "10.0.0.0/20"

public_cidrs = [
  "10.0.1.0/28",
  "10.0.2.0/28"
]
accessip = "0.0.0.0/0"

key_name = "WP"

instances_type01 = "t3.micro"

amazon_ami = {
  us-east-1    = "ami-047a51fa27710816e"
  eu-central-1 = "ami-0a6dc7529cd559185"
  eu-north-1   = "ami-02a6bfdcf8224bd77"
}