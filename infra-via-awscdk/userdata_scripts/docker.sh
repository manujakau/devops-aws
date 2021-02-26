#!/bin/bash
sudo hostnamectl set-hostname docker

sudo yum install docker -y
sudo service docker start

sudo useradd dockeradmin && sudo passwd dockeradmin
sudo usermod -aG docker dockeradmin