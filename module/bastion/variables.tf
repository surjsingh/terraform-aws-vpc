variable "environment" {
  default = "dev"
}
variable "product" {}

variable "region" {}

variable "vpc_id" {}

variable "allowed_cidr" {
  type        = "list"
  default     = ["0.0.0.0/0"]
  description = "A list of CIDR Networks to allow ssh access to."
}

variable "allowed_ipv6_cidr" {
  type        = "list"
  default     = ["::/0"]
  description = "A list of IPv6 CIDR Networks to allow ssh access to."
}

variable "allowed_security_groups" {
  type        = "list"
  default     = []
  description = "A list of Security Group ID's to allow access to."
}

variable "ami_bastion" {}

variable "instance_type_bastion" {
  default = "t2.micro"
}
variable "iam_instance_profile_bastion" {}

variable "associate_public_ip_address" {
  default = false
}

variable "key_name" {
  default = ""
}

variable "subnet_id" {
  type = "list"
  default = []
}