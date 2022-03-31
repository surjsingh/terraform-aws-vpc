#--- Main Infrastructure Variables -----#
terraform {
  required_version = ">= 0.13.1"
}


provider "aws" {
  region = "us-east-1"
//  access_key = "
//  secret_key = "
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
  type    = list
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "public_cidr_block" {
  type    = list
  default = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]
}

variable "private_cidr_block" {
  type    = list
  default = ["10.0.2.0/24", "10.0.4.0/24", "10.0.6.0/24"]
}

variable "data_cidr_block" {
  type    = list
  default = ["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]
}


#NACLS

locals {
  region = var.region

  network_acls = {
    default_outbound = [
      {
        rule_number = 900
        rule_action = "allow"
        from_port   = 0
        to_port     = 0
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
    ]
    public_inbound = [
      {
        rule_number = 900
        rule_action = "allow"
        from_port   = 49152
        to_port     = 65535
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 110
        rule_action = "allow"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      },
      {
        rule_number = 120
        rule_action = "allow"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_block  = "0.0.0.0/0"
      }
    ]
    private_inbound = [
      {
        rule_number = 900
        rule_action = "allow"
        from_port   = 49152
        to_port     = 65535
        protocol    = "tcp"
        cidr_block  = var.cidr_block
      },
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_block  = var.public_cidr_block[0]
      },
      {
        rule_number = 101
        rule_action = "allow"
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_block  = var.public_cidr_block[1]
      },
      {
        rule_number = 102
        rule_action = "allow"
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_block  = var.public_cidr_block[1]
      }


    ]
    data_inbound = [
      {
        rule_number = 100
        rule_action = "allow"
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_block  = var.private_cidr_block[0]
      },
      {
        rule_number = 101
        rule_action = "allow"
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_block  = var.private_cidr_block[1]
      },
      {
        rule_number = 102
        rule_action = "allow"
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_block  = var.private_cidr_block[2]
      }
    ]
  }
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
