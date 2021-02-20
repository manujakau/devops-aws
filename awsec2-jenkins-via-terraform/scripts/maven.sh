#!/bin/bash

sudo mkdir /opt/maven && cd /opt/maven
wget http://mirrors.estointernet.in/apache/maven/maven-3/3.6.1/binaries/apache-maven-3.6.1-bin.tar.gz
tar -xvzf apache-maven-3.6.1-bin.tar.gz
mv apache-maven-3.6.1 maven