provider "aws" {
  profile = var.profile
  region  = var.region
}

resource "aws_security_group" "allow-ssh" {
  vpc_id      = var.vpc
  name        = "allow-ssh"
  description = "security group that allows ssh and all egress traffic"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow-ssh"
  }
}

resource "aws_instance" "testvm" {
  ami                    = var.amis[var.region]
  subnet_id              = var.subnet
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]
  key_name               = var.keyName
  instance_type          = var.instanceType
  root_block_device {
    volume_size = var.volumeSize
    volume_type = var.volumeType
  }
  tags = {
    Name = var.instanceName
  }
  volume_tags = {
    Name = var.instanceName
  }
  user_data = data.template_cloudinit_config.cloudinit-example.rendered
}