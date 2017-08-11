# Bastion IAM

data "aws_iam_policy_document" "assume-role-policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com",
        "ecs.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_instance_profile" "bastion-instance-profile" {
  name = "bastion-instance-profile"
  path = "/"
  role = "${aws_iam_role.bastion-instance-role.name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "bastion-instance-role" {
  description        = "Managed by terraform"
  name               = "bastion-instance-role"
  assume_role_policy = "${data.aws_iam_policy_document.assume-role-policy.json}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_policy" "bastion-instance-policy" {
  name   = "bastion-instance-policy"
  policy = "${file("${path.module}/policies/bastion_instance.json")}"
}

resource "aws_iam_policy_attachment" "bastion-ec2-fullaccess-policy-attach" {
  name       = "bastion-ec2-fullaccess-policy"
  roles      = ["${aws_iam_role.bastion-instance-role.id}"]
  policy_arn = "${aws_iam_policy.bastion-instance-policy.arn}"
}
