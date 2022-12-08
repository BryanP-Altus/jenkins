import boto3
import time

region = 'eu-west-1'
user_data_script  = """#!/bin/bash 
instanceid=$(curl http://169.254.169.254/latest/meta-data/instance-id) 
cd /
sudo yum install -y amazon-efs-utils
sudo mkdir efs-recovery
sudo mount -t efs -o tls ${efs_id}:/ efs-recovery
cd efs-recovery/aws-backup*
sudo mv * ../.
cd ..
rm -rf aws-backup*
sudo aws efs tag-resource --resource-id ${efs_id} --tags Key=Name,Value="jenkins-${project}-efs"
sudo aws ec2 terminate-instances --instance-ids $instanceid --region eu-west-1 """

# Amazon Linux (ami-ebd02392)
def lambda_handler(event, context):
    ec2 = boto3.client('ec2', region_name=region)
    new_instance = ec2.run_instances(
                        ImageId='ami-0be9259c3f48b4026',
                        MinCount=1,
                        MaxCount=1,
                        KeyName='testE2E-delete',
                        InstanceType='t3.micro',
                        SecurityGroupIds=['${controller_sg}'],
                        SubnetId='${subnet}',
                        UserData=user_data_script)