#!/bin/bash

usage()
{
    echo 'To be called from the root/terraform-aws-vpc directory'
    echo 'Usage : ./tfplan'
    exit
}

AWS_SHARED_CREDENTIALS_FILE=~/.aws/credentials
export AWS_SHARED_CREDENTIALS_FILE
terraform init

terraform plan -out ./plan.out -lock=false $@
