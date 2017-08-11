#--- Main Infrastructure Variables -----#

variable "key_name" {
  default = "mykey" # make sure that the key exists
}

provider "aws" {
  region = "${var.region}"
}

variable "product" {
  default = "myproduct"
}

variable "region" {
  default = "eu-west-1"
}

variable "environment" {
  default = "dev"
}

variable "availability_zones" {
  type    = "list"
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "public_cidr_block" {
  type    = "list"
  default = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]
}

variable "private_cidr_block" {
  type    = "list"
  default = ["10.0.2.0/24", "10.0.4.0/24", "10.0.6.0/24"]
}

# Bastion

variable "ami_bastion" {
  default = "ami-95415ef3" # make sure the image exists in your aws region
}

variable "instance_type_bastion" {
  default = "t2.micro"
}
