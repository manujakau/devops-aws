# devops-aws
devops environment for build and release

Create jenkins server
```
cd awsec2-jenkins
terraform init
terraform plan
terraform apply
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