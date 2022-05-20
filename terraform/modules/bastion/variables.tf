variable "environment" {}

variable "product" {}

variable "region" {}

variable "vpc_id" {}

variable "key_name" {}

variable "allowed_cidr" {
  type        = list
  default     = ["0.0.0.0/0"]
  description = "A list of CIDR Networks to allow ssh access to."
}

variable "allowed_ipv6_cidr" {
  type        = list
  default     = ["::/0"]
  description = "A list of IPv6 CIDR Networks to allow ssh access to."
}

variable "ami_bastion" {}

variable "instance_type_bastion" {}

variable "iam_instance_profile_bastion" {}

variable "associate_public_ip_address" {
  default = true
}

variable "public_subnet_id" {
  type    = list
  default = []
}
