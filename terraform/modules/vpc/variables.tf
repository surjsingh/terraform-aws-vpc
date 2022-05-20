#####---  VPC Infrastructure Variables ---######

variable "cidr_block" {}
variable "product" {}
variable "environment" {}
variable "region" {}

variable "availability_zones" {
  type    = list
  default = []
}

variable "public_subnet_cidr" {
  type    = list
  default = []
}

variable "private_subnet_cidr" {
  type    = list
  default = []
}

variable "data_subnet_cidr" {
  type    = list
  default = []
}

variable "public_inbound_acl_rules" {
  type    = list
  default = []
}

variable "private_inbound_acl_rules" {
  type    = list
  default = []
}

variable "data_inbound_acl_rules" {
  type    = list
  default = []
}

variable "default_outbound_acl_rules" {
  type    = list
  default = []
}