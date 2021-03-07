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
![tomcat-deploy-job-config](https://user-images.githubusercontent.com/44127516/109269679-81aa4c80-7815-11eb-9157-72d9ba73db2e.jpg)


Setup Docker connectivity to Jenkins

Install below jenkins plugins:
Publish Over SSH

```
ssh -i "<key.pem>" ec2-user@<docker-host>
vim /etc/ssh/sshd_config #chnage PasswordAuthentication no > PasswordAuthentication yes
systemctl reload sshd
```
and add onfiguration to jenkins like below image.
![docker-ssh-jenkins](https://user-images.githubusercontent.com/44127516/109467497-ecf15a00-7a73-11eb-8fbf-d22a6bfea4b8.jpg)

Postbuild config for app publish into container job
![publish-app-to-container](https://user-images.githubusercontent.com/44127516/109615561-b92e3700-7b3c-11eb-8c53-50659dabfdca.jpg)

Setup Ansible and ansible connectivity with Docker-host

```
ssh -i "<key.pem>" ec2-user@<docker-host>
sudo useradd ansadmin
sudo echo "ansadmin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
```
```
ssh -i "<key.pem>" ec2-user@<ansible-host>
su - ansadmin
ssh-keygen
vim /etc/ansible/hosts # add docker-host private ip and localhost
ssh-copy-id ansadmin@<docker-host>
ssh-copy-id localhost
```
Set ssh access to ansible host via jenkins: 
jenkins dashboard --> Manage Jenkins --> configure system --> Publish over SSH
![ansible-ssh-jenkins](https://user-images.githubusercontent.com/44127516/109640457-2d76d380-7b59-11eb-9046-bc6ac9470c9e.jpg)

In ansible host create below files.
```
sudo mkdir -R /opt/docker
sudo chown -R ansadmin /opt/docker
sudo touch "/opt/docker/test-container.yml"
cat <<EOF | sudo tee /opt/docker/test-container.yml
---
- hosts: all
  become: true
  tasks:
  - name: stop exsiting containers
    command: docker stop devops-container
    ignore_errors: yes

  - name: remove exsiting containers
    command: docker rm devops-container
    ignore_errors: yes

  - name: remove related images
    command: docker rmi devops-image
    ignore_errors: yes

  - name: building docker image
    command: docker build -t devops-image .
    args:
      chdir: /opt/docker

  - name: start container
    command: docker run -d --name devops-container -p 8080:8080 devops-image
EOF
```

To deploy containerize application via ansible have to modify ci/cd job as below example. 
![container-via-ansible](https://user-images.githubusercontent.com/44127516/109922406-f2de7980-7cc5-11eb-947b-3d73069efffc.jpg)


To build and push iamge to dockerhub
```
sudo touch "/opt/docker/forge-image.yml"
cat <<EOF | sudo tee /opt/docker/forge-image.yml
---
- hosts: all
  become: true

  tasks:
  - name: create image
    command: docker build -t devops-image:latest .
    args:
      chdir: /opt/docker
  
  - name: tag image
    command: docker tag devops-image manuja/devops-image

  - name: push image
    command: docker push manuja/devops-image
  
  - name: remove image from local repo
    command: docker rmi devops-image:latest manuja/devops-image
    ignore_errors: yes
EOF

ansible-playbook -i hosts test-container.yml --check
```
Modify test-container.yml as below
```
---
- hosts: all
  become: true
  tasks:
  - name: stop exsiting containers
    command: docker stop devops-container
    ignore_errors: yes

  - name: remove exsiting containers
    command: docker rm devops-container
    ignore_errors: yes

  - name: remove related images
    command: docker rmi manuja/devops-image:latest
    ignore_errors: yes

  - name: pull image from hub
    command: docker pull manuja/devops-image:latest

  - name: start container
    command: docker run -d --name devops-container -p 8080:8080 manuja/devops-image:latest

```

Limit to execute ansible-playbooks on specific hosts
```
ansible-playbook -i /opt/docker/hosts /opt/docker/forge-image.yml --limit localhost;

ansible-playbook -i /opt/docker/hosts /opt/docker/test-container.yml --limit 10.192.0.229
```
![ansible-on-specific-hosts](https://user-images.githubusercontent.com/44127516/109943020-693aa600-7cdd-11eb-9dd2-98936a17abaf.jpg)


### Setup K8s 
yet to complete..

log into k8s-host
```
sudo su -
aws configure # only requred to have region
export KOPS_STATE_STORE=s3://demo.ssak8stest.com
ssh-keygen
kops create cluster --cloud=aws --zones=eu-central-1a --name=demo.ssak8stest.com --dns-zone=ssak8stest.com --dns private
kops update cluster demo.ssak8stest.com --yes --admin
```

ssh to the master:
```
ssh -i ~/.ssh/id_rsa ubuntu@api.demo.ssak8stest.com
```

To test kubctl :
```
touch nginx.yaml

cat <<EOF | tee nginx.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: test-nginx
  labels:
    app: nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
EOF

kubectl apply -f nginx.yaml

kubectl get deployments
kubectl get pods
```