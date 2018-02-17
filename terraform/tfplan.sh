#!/bin/bash

REGION = us-east-1
usage()
{
    echo 'To be called from the root/terraform-aws-vpc directory'
    echo 'Usage : ./tfplan'
    exit
}

AWS_SHARED_CREDENTIALS_FILE=~/.aws/credentials
export AWS_SHARED_CREDENTIALS_FILE
terraform init \
-backend=true \
-backend-config="bucket=terraform-demo-remote-state" \
-backend-config="key=dev/terraform.tfstate" \
-backend-config="region=$REGION" \
-get=true \
-force-copy
terraform get

terraform plan -out ./plan.out -lock=false $@
