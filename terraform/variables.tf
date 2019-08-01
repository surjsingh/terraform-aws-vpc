#--- Main Infrastructure Variables -----#
terraform {
  required_version = ">= 0.10.0, < 0.11.4"
}


provider "aws" {
  region = "${var.region}"
}

variable "key_name" {
  default = "mykey" # make sure that the key exists
}

variable "product" {
  default = "myproduct"
}

variable "region" {
  default = "us-east-1"
}

variable "environment" {
  default = "dev"
}

variable "availability_zones" {
  type    = "list"
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
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
  default = "ami-4fffc834" # make sure the image exists in your aws region
}

variable "instance_type_bastion" {
  default = "t2.micro"
}

#serviceOne

variable "ami_serviceOne" {
  default = "ami-4fffc834" # make sure the image exists in your aws region
}

variable "instance_type_serviceOne" {
  default = "t2.micro"
}

variable "password" {
  default = "qadc,sd,345"
}

