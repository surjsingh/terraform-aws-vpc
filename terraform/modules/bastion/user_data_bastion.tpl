#!/bin/bash
sleep 5
EC2_INSTANCE_ID=$(curl -s http://instance-data/latest/meta-data/instance-id)
#associate the elastic ip to instance
aws ec2 associate-address --instance-id $EC2_INSTANCE_ID --allocation-id ${elastic_ip} --region ${region}