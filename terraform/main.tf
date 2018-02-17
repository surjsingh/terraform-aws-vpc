#----Core Infrastructure file----#

data "aws_caller_identity" "current" {}

module "vpc" {
  source = "./modules/vpc"

  region              = "${var.region}"
  product             = "${var.product}"
  cidr_block          = "${var.cidr_block}"
  environment         = "${var.environment}"
  availability_zones  = "${var.availability_zones}"
  public_subnet_cidr  = "${var.public_cidr_block}"
  private_subnet_cidr = "${var.private_cidr_block}"
}

module "iam" {
  source = "./modules/iam"
}


module "bastion" {
  source = "./modules/bastion"

  product                      = "${var.product}"
  region                       = "${var.region}"
  environment                  = "${var.environment}"
  vpc_id                       = "${module.vpc.vpc_id}"
  ami_bastion                  = "${var.ami_bastion}"
  instance_type_bastion        = "${var.instance_type_bastion}"
  public_subnet_id             = "${module.vpc.vpc_public_subnet}"
  key_name                     = "${var.key_name}"
  iam_instance_profile_bastion = "${module.iam.iam_instance_profile_bastion}"
}

module "serviceOne" {
  source = "./modules/serviceOne"

  product                         = "${var.product}"
  region                          = "${var.region}"
  environment                     = "${var.environment}"
  vpc_id                          = "${module.vpc.vpc_id}"
  ami_serviceOne                  = "${var.ami_serviceOne}"
  instance_type_serviceOne        = "${var.instance_type_serviceOne}"
  private_subnet_id               = "${module.vpc.vpc_private_subnet}"
  key_name                        = "${var.key_name}"
  iam_instance_profile_serviceOne = "${module.iam.iam_instance_profile_serviceOne}"
  bastion-sg                      = "${module.bastion.bastion-sg-id}"
}
