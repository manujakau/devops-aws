from aws_cdk import (
    core,
    aws_ec2,
    aws_iam,
    aws_route53,
    aws_s3
)

class Awsec2JenkinsViaAwscdkStack(core.Stack):

    def __init__(self, scope: core.Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        # The code that defines your stack goes here
        prod_config = self.node.try_get_context('envs')['prod']

        custom_vpc = aws_ec2.Vpc(
            self,
            "DevopsVpcID",
            cidr=prod_config['vpc_config']['vpc_cidr'],
            max_azs=2,
            nat_gateways=1,
            subnet_configuration=[
                aws_ec2.SubnetConfiguration(
                    name="PublicSubnet", cidr_mask=prod_config['vpc_config']['cidr_mask'], subnet_type=aws_ec2.SubnetType.PUBLIC
                ),
                aws_ec2.SubnetConfiguration(
                    name="PrivateSubnet", cidr_mask=prod_config['vpc_config']['cidr_mask'], subnet_type=aws_ec2.SubnetType.PRIVATE
                ),
                aws_ec2.SubnetConfiguration(
                    name="DbSubnet", cidr_mask=prod_config['vpc_config']['cidr_mask'], subnet_type=aws_ec2.SubnetType.ISOLATED
                )
            ]
        )

        #simple tagging
        core.Tags.of(custom_vpc).add("Owner", "Admin")
        core.Tags.of(custom_vpc).add("Name", "DevOpsVPC")

        #import user-data scripts
        with open("userdata_scripts/jenkins.sh", mode="r") as file:
            jenkins_user_data = file.read()
        
        with open("userdata_scripts/tomcat.sh", mode="r") as file:
            tomcat_user_data = file.read()

        with open("userdata_scripts/docker.sh", mode="r") as file:
            docker_user_data = file.read()

        with open("userdata_scripts/ansible.sh", mode="r") as file:
            ansible_user_data = file.read()

        with open("userdata_scripts/kubernetes.sh", mode="r") as file:
            kubernetes_user_data = file.read()

        #ec2-jenkins
        test_server = aws_ec2.Instance(
            self,
            "ec2id",
            instance_type=aws_ec2.InstanceType(instance_type_identifier="t2.medium"),
            instance_name="Jenkins-Host",
            machine_image=aws_ec2.MachineImage.generic_linux(ami_map=
                {
                    "eu-central-1": "ami-02f9ea74050d6f812"
                }
            ),
            vpc=custom_vpc,
            vpc_subnets=aws_ec2.SubnetSelection(
                subnet_type=aws_ec2.SubnetType.PUBLIC
            ),
            key_name="WP",
            user_data=aws_ec2.UserData.custom(jenkins_user_data)
        )

        #allow web traffic
        test_server.connections.allow_from_any_ipv4(
            aws_ec2.Port.tcp(8080),
            description="allow web"
        )
        test_server.connections.allow_from_any_ipv4(
            aws_ec2.Port.tcp(22),
            description="allow ssh"
        )

        #ec2-tomcat
#        test_server2 = aws_ec2.Instance(
#            self,
#            "ec2id2",
#            instance_type=aws_ec2.InstanceType(instance_type_identifier="t2.micro"),
#            instance_name="Tomcat-Host",
#            machine_image=aws_ec2.MachineImage.generic_linux(ami_map=
#                {
#                    "eu-central-1": "ami-03c3a7e4263fd998c"
#                }
#            ),
#            vpc=custom_vpc,
#            vpc_subnets=aws_ec2.SubnetSelection(
#                subnet_type=aws_ec2.SubnetType.PUBLIC
#            ),
#            key_name="WP",
#            user_data=aws_ec2.UserData.custom(tomcat_user_data)
#        )
#
#        #allow web traffic
#        test_server2.connections.allow_from_any_ipv4(
#            aws_ec2.Port.tcp(8080),
#            description="allow web"
#        )
#        test_server2.connections.allow_from_any_ipv4(
#            aws_ec2.Port.tcp(8090),
#            description="allow web"
#        )
#        test_server2.connections.allow_from_any_ipv4(
#            aws_ec2.Port.tcp(22),
#            description="allow ssh"
#        )

        #ec2-docker
        test_server2 = aws_ec2.Instance(
            self,
            "ec2id3",
            instance_type=aws_ec2.InstanceType(instance_type_identifier="t2.micro"),
            instance_name="Docker-Host",
            machine_image=aws_ec2.MachineImage.generic_linux(ami_map=
                {
                    "eu-central-1": "ami-03c3a7e4263fd998c"
                }
            ),
            vpc=custom_vpc,
            vpc_subnets=aws_ec2.SubnetSelection(
                subnet_type=aws_ec2.SubnetType.PUBLIC
            ),
            key_name="WP",
            user_data=aws_ec2.UserData.custom(docker_user_data)
        )

        #allow web traffic
        test_server2.connections.allow_from_any_ipv4(
            aws_ec2.Port.tcp(8080),
            description="allow web"
        )
        test_server2.connections.allow_from_any_ipv4(
            aws_ec2.Port.tcp(22),
            description="allow ssh"
        )

        #ec2-ansible
        test_server4 = aws_ec2.Instance(
            self,
            "ec2id4",
            instance_type=aws_ec2.InstanceType(instance_type_identifier="t2.micro"),
            instance_name="Ansible-Host",
            machine_image=aws_ec2.MachineImage.generic_linux(ami_map=
                {
                    "eu-central-1": "ami-02f9ea74050d6f812"
                }
            ),
            vpc=custom_vpc,
            vpc_subnets=aws_ec2.SubnetSelection(
                subnet_type=aws_ec2.SubnetType.PUBLIC
            ),
            key_name="WP",
            user_data=aws_ec2.UserData.custom(ansible_user_data)
        )

        #allow web traffic
        test_server4.connections.allow_from_any_ipv4(
            aws_ec2.Port.tcp(8080),
            description="allow web"
        )
        test_server4.connections.allow_from_any_ipv4(
            aws_ec2.Port.tcp(22),
            description="allow ssh"
        )


        #ec2-k8s
        test_server5 = aws_ec2.Instance(
            self,
            "ec2id5",
            instance_type=aws_ec2.InstanceType(instance_type_identifier="t2.small"),
            instance_name="K8s-Host",
            machine_image=aws_ec2.MachineImage.generic_linux(ami_map=
                {
                    "eu-central-1": "ami-0767046d1677be5a0"
                }
            ),
            vpc=custom_vpc,
            vpc_subnets=aws_ec2.SubnetSelection(
                subnet_type=aws_ec2.SubnetType.PUBLIC
            ),
            key_name="WP",
            user_data=aws_ec2.UserData.custom(kubernetes_user_data)
        )

        #allow web traffic
        test_server5.connections.allow_from_any_ipv4(
            aws_ec2.Port.tcp(8080),
            description="allow web"
        )
        test_server5.connections.allow_from_any_ipv4(
            aws_ec2.Port.tcp(22),
            description="allow ssh"
        )

        # add permission to k8s instances profile
        test_server5.role.add_managed_policy(
            aws_iam.ManagedPolicy.from_aws_managed_policy_name(
                "AmazonSSMManagedInstanceCore"
            )
        )
        test_server5.role.add_managed_policy(
            aws_iam.ManagedPolicy.from_aws_managed_policy_name(
                "AmazonS3FullAccess"
            )
        )
        test_server5.role.add_managed_policy(
            aws_iam.ManagedPolicy.from_aws_managed_policy_name(
                "AmazonRoute53FullAccess"
            )
        )
        test_server5.role.add_managed_policy(
            aws_iam.ManagedPolicy.from_aws_managed_policy_name(
                "AmazonEC2FullAccess"
            )
        )
        test_server5.role.add_managed_policy(
            aws_iam.ManagedPolicy.from_aws_managed_policy_name(
                "IAMFullAccess"
            )
        )

        #k8s zone records
        host_zone = aws_route53.PrivateHostedZone(
            self,
            "HostedZone",
            zone_name="k8stt-test.com",
            vpc=custom_vpc
        )

        #k8s s3 bucket
        k8s_bucket = aws_s3.Bucket(
            self,
            "k8sBucket",
            bucket_name="demo-k8stt-test.com",
            versioned=True,
            removal_policy=core.RemovalPolicy.DESTROY
        )