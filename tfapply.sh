#!/bin/bash

set -x

usage()
{
    echo 'To be called from the root/landscape directory'
    echo 'Usage : ./tapply.sh'
    exit
}


AWS_SHARED_CREDENTIALS_FILE=~/.aws/credentials
export AWS_SHARED_CREDENTIALS_FILE

terraform apply -lock=false ./plan.out
