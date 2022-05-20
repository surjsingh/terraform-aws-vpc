
resource "aws_security_group" "serviceOne" {
  name        = "${var.product}-${var.environment}-serviceOne-sg"
  vpc_id      = var.vpc_id
  description = "serviceOne security group (only SSH inbound access is allowed from bastion)"

  tags = {
    Name = "${var.product}-${var.environment}-serviceOne-sg"
  }
}

resource "aws_security_group_rule" "ssh_ingress_bastion" {
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  source_security_group_id = var.bastion-sg
  security_group_id = aws_security_group.serviceOne.id
}

resource "aws_security_group_rule" "serviceOne_all_egress" {
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.serviceOne.id
}


resource "aws_launch_configuration" "serviceOne" {
  name_prefix                 = "${var.product}-${var.environment}-lc-serviceOne-"
  key_name                    = var.key_name
  image_id                    = var.ami_serviceOne
  instance_type               = var.instance_type_serviceOne
  security_groups             = ["${aws_security_group.serviceOne.id}"]
  iam_instance_profile        = var.iam_instance_profile_serviceOne

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "serviceOne" {
  name                      = "${var.product}-${var.environment}-serviceOne"
  vpc_zone_identifier       = var.private_subnet_id
  desired_capacity          = "1"
  min_size                  = "1"
  max_size                  = "1"
  health_check_grace_period = "60"
  health_check_type         = "EC2"
  force_delete              = false
  wait_for_capacity_timeout = 0
  launch_configuration      = aws_launch_configuration.serviceOne.name

  tag {
    key                 = "Name"
    value               = "${var.product}-${var.environment}-serviceOne"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
