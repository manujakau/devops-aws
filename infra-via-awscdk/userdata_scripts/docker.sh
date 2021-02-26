#!/bin/bash
sudo hostnamectl set-hostname docker

sudo yum install docker -y
sudo service docker start

sudo useradd dockeradmin && sudo echo "dockeradmin:dockeradmin" | sudo chpasswd
sudo usermod -aG docker dockeradmin