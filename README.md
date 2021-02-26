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

Set PATH for java and maven in Jenkins-Host
```
ssh -i "<key.pem>" ec2-user@xxx.xxx.xxx.xxx
vim ~/.bash_profile
JAVA_HOME=$(find /usr/lib/jvm/java-1.8* | head -n 3 | grep "/usr/lib/jvm/java-1.8.0-openjdk-1.8.0*")
M2_HOME=/usr/local/maven
PATH=$PATH:$HOME/bin:$JAVA_HOME:$M2_HOME:$M2_HOME/bin
```

Conficgure Tomcat-Host
```
$ find / -name context.xml
$ vim /opt/tomcat/webapps/host-manager/META-INF/context.xml  and /opt/tomcat/webapps/manager/META-INF/context.xml
comment below block in all above context.xml
  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" />

like:
<!--  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" /> -->

$ tomcatdown && tomcatup
```

Tomcat Admin
```
$ vim /opt/tomcat/conf/tomcat-users.xml

add below within tomcat-users block. Change values as prefer.
  <role rolename="manager-gui"/>
  <role rolename="manager-script"/>
  <role rolename="manager-jmx"/>
  <role rolename="manager-status"/>
  <user username="admin" password="admin" roles="manager-gui, manager-script, manager-jmx, manager-status"/>
  <user username="deployer" password="deployer" roles="manager-script"/>
  <user username="tomcat" password="tomcat123" roles="manager-gui"/>
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

Set Maven path

![maven-config](https://user-images.githubusercontent.com/44127516/109268445-c634e880-7813-11eb-842f-046e99bdadb5.jpg)

Install below jenkins plugins:
  Maven Integration,
  Maven Invoker,
  Deploy to container


Ex: for tomcat test deployment config within the mavaen ci/cd pipeline.
![tomcat-deploy-job-config](https://user-images.githubusercontent.com/44127516/109269330-03e64100-7815-11eb-8278-f1d9556f8a0b.jpg)