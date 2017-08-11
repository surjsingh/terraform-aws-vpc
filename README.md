# terraform-aws-vpc

## Getting Started

- Install the terraform from https://www.terraform.io/downloads.html on your dev environment and clone this repo.
- set up your aws credentials ~/.aws/credentials
- For running the terraform plan: ./tfplan.sh
- For applying the plan         : ./tfapply.sh


## VPC module

- creating 3 public and 3 private subnets across 3 availability zones for High availability
- creating 1 public and 1 private route table
- creating 3 elastic ips
- creating 3 NAT gateways associated with 3 EIPs
- Internet gateway

## Bastion module

- provision the bastion instance (aka jumpbox)

## IAM module

- provision iam access role for bastion instance

## main file usage

```hcl
    module "aws_vpc" {
    source = "./module/vpc"

    region              = "${var.region}"
    product             = "${var.product}"
    cidr_block          = "${var.cidr_block}"
    environment         = "${var.environment}"
    availability_zones  = "${var.availability_zones}"
    public_subnet_cidr  = "${var.public_cidr_block}"
    private_subnet_cidr = "${var.private_cidr_block}"
  }

  module "bastion" {
    source = "./module/bastion"

    product                      = "${var.product}"
    region                       = "${var.region}"
    environment                  = "${var.environment}"
    vpc_id                       = "${module.aws_vpc.vpc_id}"
    ami_bastion                  = "${var.ami_bastion}"
    instance_type_bastion        = "${var.instance_type_bastion}"
    subnet_id                    = "${module.aws_vpc.vpc_public_subnet}"
    key_name                     = "${var.key_name}"
    iam_instance_profile_bastion = "${module.iam.iam_instance_profile_bastion}"
  }
```
