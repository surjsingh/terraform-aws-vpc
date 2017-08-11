#!/bin/bash

set -x

usage()
{
    echo 'To be called from the root/landscape directory'
    echo 'Usage : ./tapply <env>'
    echo 'env is one of: dev, admin, automation, global, staging'
    exit
}

if [ $# -eq 0 ]
  then
    echo "No arguments supplied."
    usage
fi

AWS_SHARED_CREDENTIALS_FILE=~/.aws/credentials
export AWS_SHARED_CREDENTIALS_FILE

terraform apply -lock=false ./plan.out
