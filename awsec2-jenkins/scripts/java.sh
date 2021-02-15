#!/bin/bash
sudo yum -y install java-1.8.0-openjdk-devel
JAVA_HOME=$(find /usr/lib/jvm/java-1.8* | head -n 3 | grep "/usr/lib/jvm/java-1.8.0-openjdk-1.8.0*")
export JAVA_HOME
PATH=$PATH:$JAVA_HOME