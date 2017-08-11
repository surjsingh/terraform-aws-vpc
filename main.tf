#####----Core Infrastructure file----####

data "aws_caller_identity" "current" {}

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
