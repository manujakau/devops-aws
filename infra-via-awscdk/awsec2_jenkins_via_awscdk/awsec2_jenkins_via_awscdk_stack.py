from aws_cdk import (
    core,
    aws_ec2
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
        with open("userdata_scripts/setup.sh", mode="r") as file:
            user_data = file.read()
        
        with open("userdata_scripts/tomcat.sh", mode="r") as file:
            user_data2 = file.read()

        with open("userdata_scripts/docker.sh", mode="r") as file:
            user_data3 = file.read()

        #ec2-jenkins
        test_server = aws_ec2.Instance(
            self,
            "ec2id",
            instance_type=aws_ec2.InstanceType(instance_type_identifier="t2.micro"),
            instance_name="Jenkins-Host",
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
            user_data=aws_ec2.UserData.custom(user_data)
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
        test_server2 = aws_ec2.Instance(
            self,
            "ec2id2",
            instance_type=aws_ec2.InstanceType(instance_type_identifier="t2.micro"),
            instance_name="Tomcat-Host",
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
            user_data=aws_ec2.UserData.custom(user_data2)
        )

        #allow web traffic
        test_server2.connections.allow_from_any_ipv4(
            aws_ec2.Port.tcp(8080),
            description="allow web"
        )
        test_server2.connections.allow_from_any_ipv4(
            aws_ec2.Port.tcp(8090),
            description="allow web"
        )
        test_server2.connections.allow_from_any_ipv4(
            aws_ec2.Port.tcp(22),
            description="allow ssh"
        )

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
            user_data=aws_ec2.UserData.custom(user_data3)
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