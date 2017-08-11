#OUTPUTS

output "iam_instance_profile_bastion" {
  value = "${aws_iam_instance_profile.bastion-instance-profile.id}"
}
