#####----Core Infrastructure file for DEV environment----####

#managing and querying tf state
terraform {
  backend "s3" {
    bucket = "exterion-terraform-remote-state"
    key    = "dev/terraform.tfstate"
    region = "eu-west-1"
  }
}

data "terraform_remote_state" "globalstate" {
  backend      = "s3"
  config {
    region     = "eu-west-1"
    bucket     = "exterion-terraform-remote-state"
    key        = "global/terraform.tfstate"
  }
}

data "terraform_remote_state" "adminstate" {
  backend      = "s3"
  config {
    region     = "eu-west-1"
    bucket     = "exterion-terraform-remote-state"
    key        = "admin/terraform.tfstate"
  }
}

data "aws_caller_identity" "current" {}

module "aws_vpc" {
  source = "../module/vpc"

  region                                = "${var.region}"
  product                               = "${var.product}"
  cidr_block                            = "${var.cidr_block}"
  environment                           = "${var.environment}"
  availability_zones                    = "${var.availability_zones}"
  public_subnet_cidr                    = "${var.public_cidr_block}"
  private_subnet_cidr                   = "${var.private_cidr_block}"
  security_group_default_egress_public  = "${var.security_group_default_egress_public}"
  security_group_default_egress_private = "${var.security_group_default_egress_private}"
}

module "vpc-peer" {
  source = "../module/vpc-peer"

  current_vpcid = "${module.aws_vpc.vpc_id}"
  environment = "${var.environment}"
  product = "${var.product}"
  autoaccept_peering = "true"
  public_routetableid = "${module.aws_vpc.vpc_public_routetable}"
  private_routetableid = "${module.aws_vpc.vpc_private_routetable}"
  admin_cidr_block     = "${data.terraform_remote_state.adminstate.admin_cidr}"
  admin_vpcid          = "${data.terraform_remote_state.adminstate.admin_vpcid}"

}

module "bastion" {
  source = "../module/bastion"

  product               = "${var.product}"
  region                = "${var.region}"
  environment           = "${var.environment}"
  vpc_id                = "${module.aws_vpc.vpc_id}"
  ami_bastion           = "${var.ami_bastion}"
  instance_type_bastion = "${var.instance_type_bastion}"
  subnet_id             = "${module.aws_vpc.vpc_public_subnet}"
  key_name              = "${var.key_name}"
  iam_instance_profile_bastion = "${data.terraform_remote_state.globalstate.iam_instance_profile_bastion}"

}

module "mongodb" {
  source = "../module/mongodb"

  vpc_id             = "${module.aws_vpc.vpc_id}"
  availability_zones = "${var.availability_zones}"
  mongo_ami_id       = "${var.mongo_ami_id}"
  environment        = "${var.environment}"
  region             = "${var.region}"
  subnet_id          = "${module.aws_vpc.vpc_private_subnet}"
  mongo_cluster      = "${var.mongo_cluster}"
  product            = "${var.product}"
  key_name           = "${var.key_name}"
  allowbastion-sg    = "${module.bastion.bastion-sg-id}"
  allowemr-sg        = "${module.emr.emr_sg_id}"
  r53_zone_id        = "${data.terraform_remote_state.globalstate.r53_extinternal_zoneid}"
  ebs_vol_id         = "${var.ebs_vol_id}"
  mongo_ecr_repo     = "${data.terraform_remote_state.globalstate.ecr_repo_mongo}"
  allowjenkinslave-sg   = "${data.terraform_remote_state.adminstate.jenkins-slave-sg}"
  iam_instance_profile_mongo = "${data.terraform_remote_state.globalstate.iam_instance_profile_mongo}"
}

module "s3" {
  source = "../module/s3"

  environment = "${var.environment}"
}

module "emr" {
  source = "../module/emr"

  product      = "${var.product}"
  environment  = "${var.environment}"
  vpc_id       = "${module.aws_vpc.vpc_id}"
  log_uri      = "s3n://${module.s3.emr-log-bucket}/"
  cluster_size = "${var.emr_cluster_size}"
  emr_subnet   = "${module.aws_vpc.vpc_private_subnet}"
  core_instance_count   = "${var.core_instance_count}"
  core_instance_type    = "${var.core_instance_type}"
  master_instance_type  = "${var.master_instance_type}"
  allowbastion-sg       = "${module.bastion.bastion-sg-id}"
  key_name              = "${var.key_name}"
}


module "ecs" {
  source = "../module/ecs"

  subnet_id               = "${module.aws_vpc.vpc_private_subnet}"
  public_subnet_id        = "${module.aws_vpc.vpc_public_subnet}"
  availability_zones      = "${var.availability_zones}"
  vpc_id                  = "${module.aws_vpc.vpc_id}"
  microservice-key-name   = "${var.key_name}"
  ecs-role                = "${data.terraform_remote_state.globalstate.iam_role_ecs}"
  ApiVersion              = "${var.ApiVersion}"
  DynamicsAXUrl           = "${var.DynamicsAXUrl}"
  ApiVersion              = "${var.ApiVersion}"
  DynamicsAXUserName      = "${var.DynamicsAXUserName}"
  DynamicsAxPassword      = "${var.DynamicsAxPassword}"
  DynamicsIntegrationMode = "${var.DynamicsIntegrationMode}"
}

module "airflow" {
  source = "../module/airflow"

  vpc_id                               = "${module.aws_vpc.vpc_id}"
  availability_zones                   = "${var.availability_zones}"
  airflow_ami_id                       = "${var.airflow_ami_id}"
  environment                          = "${var.environment}"
  region                               = "${var.region}"
  subnet_id                            = "${module.aws_vpc.vpc_private_subnet}"
  product                              = "${var.product}"
  key_name                             = "${var.key_name}"
  airflow_ecr_repo                     = "${var.airflow_ecr_repo}"
  airflow_instance_type                = "${var.airflow_instance_type}"
  iam_instance_profile_airflow         = "${data.terraform_remote_state.globalstate.iam_instance_profile_airflow}"
  allowbastion-sg                      = "${module.bastion.bastion-sg-id}"
  airflow_private_ip                   = "${var.airflow_private_ip}" #TODO - figure out a different way
}

# ZONE ASSOCIATION

/*resource "aws_route53_zone_association" "attach-vpc" {
  zone_id = "${var.zoneid_extinternal}"
  vpc_id  = "${module.aws_vpc.vpc_id}"
}
*/