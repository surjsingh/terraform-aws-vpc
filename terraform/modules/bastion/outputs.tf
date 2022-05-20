#OUTPUTS

output "bastion-sg-id" {
  value = aws_security_group.bastion.id
}

output "bastion-eip" {
  value = aws_eip.bastion.public_ip
}
