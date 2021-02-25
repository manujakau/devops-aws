#!/bin/bash
sudo hostnamectl set-hostname tomcat
sudo yum -y install java-1.8.0-openjdk-devel wget

cd /opt
sudo wget https://downloads.apache.org/tomcat/tomcat-8/v8.5.63/bin/apache-tomcat-8.5.63.tar.gz
sudo tar -xvzf apache-tomcat-8.5.63.tar.gz
sudo mv apache-tomcat-8.5.63 tomcat
sudo chmod +x /opt/tomcat/bin/startup.sh
sudo chmod +x /opt/tomcat/bin/shutdown.sh
sudo ln -s /opt/tomcat/bin/startup.sh /usr/local/bin/tomcatup
sudo ln -s /opt/tomcat/bin/shutdown.sh /usr/local/bin/tomcatdown
tomcatup