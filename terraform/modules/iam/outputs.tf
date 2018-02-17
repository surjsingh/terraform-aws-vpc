#OUTPUTS

output "iam_instance_profile_bastion" {
  value = "${aws_iam_instance_profile.bastionbox-instance-profile.id}"
}

output "iam_instance_profile_serviceOne" {
  value = "${aws_iam_instance_profile.serviceOne-instance-profile.id}"
}
