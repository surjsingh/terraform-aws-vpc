#!/bin/bash

usage()
{
    echo 'To be called from the root/terraform-aws-vpc directory'
    echo 'Usage : ./tplan'
    exit
}

AWS_SHARED_CREDENTIALS_FILE=~/.aws/credentials
export AWS_SHARED_CREDENTIALS_FILE

if [ -d ".terraform" ]; then
  rm -rf .terraform
fi

terraform get

terraform plan -out ./plan.out -lock=false
