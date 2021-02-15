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