variable "environment" {}

variable "product" {}

variable "region" {}

variable "vpc_id" {}

variable "key_name" {}

variable "ami_serviceOne" {}

variable "instance_type_serviceOne" {}

variable "iam_instance_profile_serviceOne" {}

variable "private_subnet_id" {
  type    = list
  default = []
}

variable "bastion-sg" {}