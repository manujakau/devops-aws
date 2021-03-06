#!/bin/bash
sudo hostnamectl set-hostname docker

sudo yum install docker -y
sudo service docker start

password="admin"
sudo useradd dockeradmin
yes $password | sudo passwd dockeradmin
sudo usermod -aG docker dockeradmin