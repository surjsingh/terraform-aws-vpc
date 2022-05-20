resource "aws_eip" "bastion" {
  vpc = true
}

resource "aws_security_group" "bastion" {
  name        = "${var.product}-${var.environment}-bastion-sg"
  vpc_id      = var.vpc_id
  description = "Bastion security group (only SSH inbound access is allowed)"

  tags = {
    Name = "${var.product}-${var.environment}-bastion-sg"
  }
  
}

resource "aws_security_group_rule" "ssh_ingress" {
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr
  ipv6_cidr_blocks  = var.allowed_ipv6_cidr
  security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "icmp_ingress" {
  type              = "ingress"
  from_port         = "8"
  to_port           = "0"
  protocol          = "icmp"
  cidr_blocks       = var.allowed_cidr
  security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "bastion_all_egress" {
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.bastion.id
}

data "template_file" "user_data_bastion" {
  template = "${file("${path.module}/user_data_bastion.tpl")}"

  vars = {
    region     = var.region
    elastic_ip = aws_eip.bastion.id
  }
}

resource "aws_launch_configuration" "bastion" {
  name_prefix                 = "${var.product}-${var.environment}-lc-bastion-"
  key_name                    = var.key_name
  image_id                    = var.ami_bastion
  instance_type               = var.instance_type_bastion
  security_groups             = ["${aws_security_group.bastion.id}"]
  associate_public_ip_address = var.associate_public_ip_address
  iam_instance_profile        = var.iam_instance_profile_bastion
  user_data                   = data.template_file.user_data_bastion.rendered

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bastion" {
  name                      = "${var.product}-${var.environment}-bastion"
  vpc_zone_identifier       = var.public_subnet_id
  desired_capacity          = "0"
  min_size                  = "0"
  max_size                  = "1"
  health_check_grace_period = "60"
  health_check_type         = "EC2"
  force_delete              = false
  wait_for_capacity_timeout = 0
  launch_configuration      = aws_launch_configuration.bastion.name

  tag {
    key                 = "Name"
    value               = "${var.product}-${var.environment}-bastion"
    propagate_at_launch = true
  }

  tag {
    key                 = "EIP"
    value               = aws_eip.bastion.id
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
