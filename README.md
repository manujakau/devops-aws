# devops-aws
devops environment for build and release

Create jenkins server using Terraform
```
cd awsec2-jenkins-via-terraform
terraform init
terraform plan
terraform apply
```

Create jenkins server using aws-cdk
```
cd awsec2-jenkins-via-awscdk
$ python3 -m venv .venv
$ source .venv/bin/activate
$ pip3 install -r requirements.txt
$ cdk bootstrap
$ cdk ls
$ cdk deploy
```

Set PATH for java and maven
```
ssh -i "<key.pem>" ec2-user@xxx.xxx.xxx.xxx
vim ~/.bash_profile
JAVA_HOME=$(find /usr/lib/jvm/java-1.8* | head -n 3 | grep "/usr/lib/jvm/java-1.8.0-openjdk-1.8.0*")
M2_HOME=/usr/local/maven
PATH=$PATH:$HOME/bin:$JAVA_HOME:$M2_HOME:$M2_HOME/bin
```

Get admin password for setup jenkins config
```
ssh -i "<key.pem>" ec2-user@xxx.xxx.xxx.xxx
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Modify jenkins jdk path.(get java_home via below script)
```
sudo find /usr/lib/jvm/java-1.8* | head -n 3 | grep "/usr/lib/jvm/java-1.8.0-openjdk-1.8.0*"
```

![jenkins-jdk](https://user-images.githubusercontent.com/44127516/107953356-b6abd900-6fa3-11eb-8517-a64870e287b3.png)