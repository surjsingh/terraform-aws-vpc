## --Security Groups and respective rules ---###


## default security group created along with the VPC (Not specifying anything will remove all the default open rules)
resource "aws_default_security_group" "default" {
  vpc_id  = "${aws_vpc.main.id}"
  tags = {
    Name      = "${var.environment}-sg-default"
  }
}

resource "aws_security_group" "default_public" {
  name        = "${var.environment}-sg-default-public"
  description = "default VPC security group for public subnets"
  vpc_id = "${aws_vpc.main.id}"
  tags = {
    Name      = "${var.environment}-sg-default-public"
  }
}

resource "aws_security_group_rule" "default_ssh_ingress_public" {
  type                      = "ingress"
  from_port                 = "0"
  to_port                   = "0"
  protocol                  = "-1"
  source_security_group_id  = "${aws_security_group.default_public.id}"
  security_group_id         = "${aws_security_group.default_public.id}"
}

resource "aws_security_group_rule" "default_ssh_egress_public" {
  type                      = "egress"
  from_port                 = "0"
  to_port                   = "0"
  protocol                  = "-1"
  cidr_blocks               = ["${var.security_group_default_egress_public["cidr_blocks"]}"]
  security_group_id         = "${aws_security_group.default_public.id}"

}

resource "aws_security_group" "default_private" {
  name        = "${var.environment}-sg-default-private"
  description = "default VPC security group for private subnets"
  vpc_id = "${aws_vpc.main.id}"
  tags = {
    Name      = "${var.environment}-sg-default-private"
  }
}

resource "aws_security_group_rule" "default_ssh_ingress_private" {
  type                      = "ingress"
  from_port                 = "0"
  to_port                   = "0"
  protocol                  = "-1"
  source_security_group_id  = "${aws_security_group.default_private.id}"
  security_group_id         = "${aws_security_group.default_private.id}"

}

resource "aws_security_group_rule" "default_ssh_egress_private" {
  type                      = "egress"
  from_port                 = "0"
  to_port                   = "0"
  protocol                  = "-1"
  cidr_blocks               = ["${var.security_group_default_egress_private["cidr_blocks"]}"]
  security_group_id         = "${aws_security_group.default_private.id}"

}
