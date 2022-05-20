# Bastion IAM

data "aws_iam_policy_document" "assume-role-policy-bastionbox" {
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

resource "aws_iam_instance_profile" "bastionbox-instance-profile" {
  name = "bastionbox-instance-profile"
  path = "/"
  role = aws_iam_role.bastionbox-instance-role.name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "bastionbox-instance-role" {
  description        = "Managed by terraform"
  name               = "bastionbox-instance-role"
  assume_role_policy = data.aws_iam_policy_document.assume-role-policy-bastionbox.json

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_policy" "bastionbox-instance-policy" {
  name   = "bastionbox-instance-policy"
  policy = file("${path.module}/policies/bastionbox_instance.json")
}

resource "aws_iam_policy_attachment" "bastionbox-ec2-fullaccess-policy-attach" {
  name       = "bastionbox-ec2-fullaccess-policy"
  roles      = ["${aws_iam_role.bastionbox-instance-role.id}"]
  policy_arn = aws_iam_policy.bastionbox-instance-policy.arn
}
