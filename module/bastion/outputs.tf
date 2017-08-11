#OUTPUTS

output "bastion-sg-id" {
  value = "${aws_security_group.bastion.id}"
}
