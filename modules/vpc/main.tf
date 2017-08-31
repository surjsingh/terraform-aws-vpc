#-----Core Infrastructure Template VPC------#

#----VPC----#
resource "aws_vpc" "main" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags {
    Name = "${var.product}-${var.environment}-vpc"
  }
}

#----GATEWAYS----#
# Create necessary gateways for connectivity

resource "aws_internet_gateway" "igw" {
  depends_on = ["aws_vpc.main"]
  vpc_id     = "${aws_vpc.main.id}"

  tags {
    Name = "${var.environment} IGW"
  }
}

resource "aws_eip" "nat" {
  depends_on = ["aws_vpc.main"]
  vpc        = true
  count      = "${length(var.availability_zones)}"
}

resource "aws_nat_gateway" "ngw" {
  depends_on    = ["aws_internet_gateway.igw"]
  count         = "${length(var.availability_zones)}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
}

#----SUBNETS----#

resource "aws_subnet" "public" {
  depends_on              = ["aws_vpc.main"]
  vpc_id                  = "${aws_vpc.main.id}"
  count                   = "${length(var.public_subnet_cidr)}"
  cidr_block              = "${element(var.public_subnet_cidr, count.index)}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.environment}-public-${element(var.availability_zones, count.index)}"
  }
}

resource "aws_subnet" "private" {
  depends_on              = ["aws_vpc.main"]
  vpc_id                  = "${aws_vpc.main.id}"
  count                   = "${length(var.private_subnet_cidr)}"
  cidr_block              = "${element(var.private_subnet_cidr, count.index)}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = false

  tags {
    Name = "${var.environment}-private-${element(var.availability_zones, count.index)}"
  }
}

#-----ROUTE TABLES-----#

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "${var.environment}-public-route"
  }
}

resource "aws_route" "route-igw" {

  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}

resource "aws_route_table" "private" {
  count  = "${length(var.private_subnet_cidr)}"
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "${var.environment}-private-route"
  }
}

resource "aws_route" "route-natgw" {
  count                  = "${length(var.private_subnet_cidr)}"
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.ngw.*.id, count.index)}"
}

#------ROUTE TABLE ASSOCIATIONS------#

resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnet_cidr)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "private" {
  count          = "${length(var.private_subnet_cidr)}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}
