#!/bin/bash
sudo yum -y install java-1.8.0-openjdk-devel
cd ~
cat <<EOF | sudo tee .bash_profile
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

JAVA_HOME=$(find /usr/lib/jvm/java-1.8* | head -n 3 | grep "/usr/lib/jvm/java-1.8.0-openjdk-1.8.0*")
PATH=$PATH:$HOME/bin:$JAVA_HOME

export PATH
EOF