#!/bin/bash
sudo yum -y install java-1.8.0-openjdk-devel

sudo yum -y install wget
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum -y install jenkins

sudo service jenkins start
sudo chkconfig jenkins on

sudo yum -y install git

sudo wget https://downloads.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
sudo tar -xvzf apache-maven-3.6.3-bin.tar.gz
sudo mv apache-maven-3.6.3 maven && sudo mv maven /usr/local/

sudo hostnamectl set-hostname jenkins