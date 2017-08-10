##########  Dev Infrastructure Variables ##########

variable "key_name" {
  default = "exterion-dev"
}

provider "aws" {
  region = "${var.region}"
}

variable "product" {
  default = "exterion"
}

variable "region" {
  default = "eu-west-1"
}

variable "environment" {
  default = "dev"
}

variable "availability_zones" {
  type = "list"
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "public_cidr_block" {
  type = "list"
  default = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]
}

variable "private_cidr_block" {
  type = "list"
  default = ["10.0.2.0/24", "10.0.4.0/24", "10.0.6.0/24"]
}

variable "security_group_default_egress_public" {
  type = "map"

  default = {
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "security_group_default_egress_private" {
  type = "map"

  default = {
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#EMR

variable "master_instance_type" {
  default = "m3.xlarge"
}
variable "core_instance_type" {
  default = "m3.xlarge"
}
variable "core_instance_count" {
  default = 1
}
variable "emr_cluster_size" {
  default = 2
}

#mongo module Variables

variable "mongo_ami_id" {
  default = "ami-f628c68f"
}

variable "mongo_instance_type" {
  default = "t2.micro"
}

variable "mongo_cluster" {
  default = 1
}

variable "ebs_size" {
  default = 10
}

variable "ebs_type" {
  default = "standard"
}

variable "ebs_vol_id" {
  default ="snap-0f6a48de670d374a7"
}

# Bastion

variable "ami_bastion" {
  default = "ami-95415ef3"
}

variable "instance_type_bastion" {
  default = "t2.micro"
}

variable DynamicsAXUrl { default= "random"}
variable ApiVersion {default= "random"}
variable DynamicsAXUserName {default= "random"}
variable DynamicsAxPassword {default= "random"}
variable DynamicsIntegrationMode {default= "dev"}
# Airflow module Variables

variable "airflow_ami_id" {
  default = "ami-f628c68f"
}

variable "airflow_instance_type" {
  default = "t2.micro"
}

variable "airflow_ecr_repo" {
  default = "712741856094.dkr.ecr.eu-west-1.amazonaws.com/airflow"
}

variable "airflow_private_ip" {
  default = "10.0.2.39"
}