#!/usr/bin/env python3

from aws_cdk import core

from awsec2_jenkins_via_awscdk.awsec2_jenkins_via_awscdk_stack import Awsec2JenkinsViaAwscdkStack


app = core.App()
Awsec2JenkinsViaAwscdkStack(app, "awsec2-jenkins-via-awscdk")

app.synth()
