#OUTPUTS:

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "vpc_public_subnet" {
  value = "${aws_subnet.public.*.id}"
}

output "vpc_private_subnet" {
  value = "${aws_subnet.private.*.id}"
}

output "vpc_data_subnet" {
  value = "${aws_subnet.data.*.id}"
}

output "vpc_public_routetable" {
  value = "${aws_route_table.public.id}"
}

output "vpc_private_routetable" {
  value = "${aws_route_table.private.*.id}"
}

