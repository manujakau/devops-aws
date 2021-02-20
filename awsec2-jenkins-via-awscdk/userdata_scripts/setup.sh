#!/bin/bash
sudo yum -y install java-1.8.0-openjdk-devel

sudo yum -y install wget
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum -y install jenkins

sudo service jenkins start
sudo chkconfig jenkins on

sudo yum -y install git

sudo mkdir /opt/maven && cd /opt/maven
sudo wget http://mirrors.estointernet.in/apache/maven/maven-3/3.6.1/binaries/apache-maven-3.6.1-bin.tar.gz
sudo tar -xvzf apache-maven-3.6.1-bin.tar.gz
sudo mv apache-maven-3.6.1 maven

cd ~
cat <<EOF | sudo tee .bash_profile
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

JAVA_HOME=$(find /usr/lib/jvm/java-1.8* | head -n 3 | grep "/usr/lib/jvm/java-1.8.0-openjdk-1.8.0*")
M2_HOME=/opt/maven/apache-maven-3.6.1
M2=$M2_HOME/bin
PATH=$PATH:$HOME/bin:$JAVA_HOME:$M2_HOME:$M2

export PATH
EOF

sudo hostnamectl set-hostname jenkins