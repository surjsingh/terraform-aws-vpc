# serviceOne IAM

data "aws_iam_policy_document" "assume-role-policy-serviceOne" {
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

resource "aws_iam_instance_profile" "serviceOne-instance-profile" {
  name = "serviceOne-instance-profile"
  path = "/"
  role = aws_iam_role.serviceOne-instance-role.name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "serviceOne-instance-role" {
  description        = "Managed by terraform"
  name               = "serviceOne-instance-role"
  assume_role_policy = data.aws_iam_policy_document.assume-role-policy-serviceOne.json

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_policy" "serviceOne-instance-policy" {
  name   = "serviceOne-instance-policy"
  policy = file("${path.module}/policies/serviceOne_instance.json")
}

resource "aws_iam_policy_attachment" "serviceOne-ec2-fullaccess-policy-attach" {
  name       = "serviceOne-ec2-fullaccess-policy"
  roles      = ["${aws_iam_role.serviceOne-instance-role.id}"]
  policy_arn = aws_iam_policy.serviceOne-instance-policy.arn
}
