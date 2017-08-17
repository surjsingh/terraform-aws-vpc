# terraform-aws-vpc

## Getting Started

- Install the terraform from https://www.terraform.io/downloads.html on your dev environment.
- create a key-pair in aws region that will be used to provision infra.
- clone this repo and update the variables.tf in root location with the below mandatory parameters:
    1. key_name : <aws_key_name >
    2. region   : <aws_region>
    3. availability_zones : < 3 availability_zones>
- For running the terraform plan:   `./tfplan.sh`
- For applying the plan         :   `./tfapply.sh`

### NOTE: For destroying the environment run `terraform plan -destroy` to look at your destroy plan and then execute 'terraform destroy`


## VPC module

- A `highly available architecture` that spans across three Availability Zones.
- A VPC configured with `public and private subnets` according to AWS best practices, to provide you with your own virtual network on AWS.
- `Public and private` route tables for routing internal and external traffic.
- An `Internet gateway` to allow access to the Internet. This gateway is used by the bastion hosts to send and receive traffic.
- `Managed NAT gateways` to allow outbound Internet access for resources in the private subnets.

## Bastion module

- A `Linux bastion host` in each public subnet with an Elastic IP address to allow inbound Secure Shell (SSH) access to EC2 instances in public and private subnets.
- A `security group` for fine-grained inbound access control.
- An Amazon `EC2 Auto Scaling group` with a configurable number of instances.
- `Launch configuration` to associate with ASG specifying the user-data to associate the elastic ip.
- `Elastic IP` addresses to associate with bastion host instance.

## IAM module

- `bastion instance role` with trust policy and iam access policy to associate the elastic ip.

## Architecture diagram
* Depicting 2 AZs

![image](https://user-images.githubusercontent.com/11966883/29213723-25a0aa38-7ec2-11e7-8c96-9791d83b5700.png)

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
