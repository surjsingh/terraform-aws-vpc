#OUTPUTS

output "bastion-sg-id" {
  value = "${aws_security_group.bastion.id}"
}

output "bastion-public-ip-enabled" {
  value = "${var.associate_public_ip_address}"
}

output "bastion-eip" {
  value = "${aws_eip.bastion.public_ip}"
}
