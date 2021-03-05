#!/bin/bash
sudo hostnamectl set-hostname k8s

sudo apt update -y && sudo apt upgrade -y
sudo apt install -y unzip \
                    curl \
                    python3-pip

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/

curl -LO https://github.com/kubernetes/kops/releases/download/v1.19.1/kops-linux-amd64
chmod +x kops-linux-amd64
sudo mv kops-linux-amd64 /usr/local/bin/kops