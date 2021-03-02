#!/bin/bash
sudo hostnamectl set-hostname ansible

sudo yum update -y && sudo amazon-linux-extras install ansible2 -y

sudo yum install docker -y
sudo service docker start

password="admin"
sudo useradd ansadmin
yes $password | sudo passwd ansadmin
sudo usermod -aG docker ansadmin

sudo echo "ansadmin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
sed -i "s/PasswordAuthentication.*/PasswordAuthentication yes/g" /etc/ssh/sshd_config
sudo systemctl reload sshd