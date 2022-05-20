#-----Core Infrastructure Template VPC------#

#----VPC----#
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "${var.product}-${var.environment}-vpc"
  }
}

#----GATEWAYS----#
# Create necessary gateways for connectivity

resource "aws_internet_gateway" "igw" {
  depends_on = [aws_vpc.main]
  vpc_id     = aws_vpc.main.id

  tags = {
    Name = "${var.environment} IGW"
  }
}

resource "aws_eip" "nat" {
  depends_on = [aws_vpc.main]
  vpc        = true
  count      = length(var.availability_zones)
}

resource "aws_nat_gateway" "ngw" {
  depends_on    = [aws_internet_gateway.igw]
  count         = length(var.availability_zones)
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
}

#----SUBNETS----#

resource "aws_subnet" "public" {
  depends_on              = [aws_vpc.main]
  vpc_id                  = aws_vpc.main.id
  count                   = length(var.public_subnet_cidr)
  cidr_block              = element(var.public_subnet_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-public-${element(var.availability_zones, count.index)}"
  }
}

resource "aws_subnet" "private" {
  depends_on              = [aws_vpc.main]
  vpc_id                  = aws_vpc.main.id
  count                   = length(var.private_subnet_cidr)
  cidr_block              = element(var.private_subnet_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.environment}-private-${element(var.availability_zones, count.index)}"
  }
}

resource "aws_subnet" "data" {
depends_on              = [aws_vpc.main]
vpc_id                  = aws_vpc.main.id
count                   = length(var.data_subnet_cidr)
cidr_block              = element(var.data_subnet_cidr, count.index)
availability_zone       = element(var.availability_zones, count.index)
map_public_ip_on_launch = false

tags = {
  Name = "${var.environment}-data-${element(var.availability_zones, count.index)}"
  }
}


#-----ROUTE TABLES-----#

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-public-route"
  }
}

resource "aws_route" "route-igw" {

  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table" "private" {
  count  = length(var.private_subnet_cidr)
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-private-route-${element(var.availability_zones, count.index)}"
  }
}

resource "aws_route" "route-natgw" {
  count                  = length(var.private_subnet_cidr)
  route_table_id         = element(aws_route_table.private[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.ngw[*].id, count.index)
}

resource "aws_route_table" "data" {
vpc_id = aws_vpc.main.id

tags = {
  Name = "${var.environment}-data-route"
  }
}

#------ROUTE TABLE ASSOCIATIONS------#

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = element(aws_route_table.public[*].id, count.index)
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr)
  subnet_id = element(aws_subnet.private[*].id, count.index)
  route_table_id = element(aws_route_table.private[*].id, count.index)
}

resource "aws_route_table_association" "data" {
  count = length(var.data_subnet_cidr)
  subnet_id = element(aws_subnet.data[*].id, count.index)
  route_table_id = element(aws_route_table.data[*].id, count.index)
}

#------NACLS-----------------#

#PUBLIC ACL
resource "aws_network_acl" "public" {
vpc_id = aws_vpc.main.id
subnet_ids = aws_subnet.public[*].id

tags = {
  Name = "${var.environment}-public-nacl"
  }
}

resource "aws_network_acl_rule" "public_inbound" {

  count = length(var.public_inbound_acl_rules)
  network_acl_id = aws_network_acl.public.id

  egress          = false
  rule_number     = var.public_inbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.public_inbound_acl_rules[count.index]["rule_action"]
  from_port       = lookup(var.public_inbound_acl_rules[count.index], "from_port", null)
  to_port         = lookup(var.public_inbound_acl_rules[count.index], "to_port", null)
  icmp_code       = lookup(var.public_inbound_acl_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.public_inbound_acl_rules[count.index], "icmp_type", null)
  protocol        = var.public_inbound_acl_rules[count.index]["protocol"]
  cidr_block      = lookup(var.public_inbound_acl_rules[count.index], "cidr_block", null)
  ipv6_cidr_block = lookup(var.public_inbound_acl_rules[count.index], "ipv6_cidr_block", null)
}

resource "aws_network_acl_rule" "public_outbound" {

  count = length(var.default_outbound_acl_rules)
  network_acl_id = aws_network_acl.public.id

  egress          = true
  rule_number     = var.default_outbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.default_outbound_acl_rules[count.index]["rule_action"]
  from_port       = lookup(var.default_outbound_acl_rules[count.index], "from_port", null)
  to_port         = lookup(var.default_outbound_acl_rules[count.index], "to_port", null)
  icmp_code       = lookup(var.default_outbound_acl_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.default_outbound_acl_rules[count.index], "icmp_type", null)
  protocol        = var.default_outbound_acl_rules[count.index]["protocol"]
  cidr_block      = lookup(var.default_outbound_acl_rules[count.index], "cidr_block", null)
  ipv6_cidr_block = lookup(var.default_outbound_acl_rules[count.index], "ipv6_cidr_block", null)
}

#PRIVATE ACL

resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.main.id
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "${var.environment}-private-nacl"
  }
}

resource "aws_network_acl_rule" "private_inbound" {

  count = length(var.private_inbound_acl_rules)
  network_acl_id = aws_network_acl.private.id

  egress          = false
  rule_number     = var.private_inbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.private_inbound_acl_rules[count.index]["rule_action"]
  from_port       = lookup(var.private_inbound_acl_rules[count.index], "from_port", null)
  to_port         = lookup(var.private_inbound_acl_rules[count.index], "to_port", null)
  icmp_code       = lookup(var.private_inbound_acl_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.private_inbound_acl_rules[count.index], "icmp_type", null)
  protocol        = var.private_inbound_acl_rules[count.index]["protocol"]
  cidr_block      = lookup(var.private_inbound_acl_rules[count.index], "cidr_block", null)
  ipv6_cidr_block = lookup(var.private_inbound_acl_rules[count.index], "ipv6_cidr_block", null)
}


resource "aws_network_acl_rule" "private_outbound" {

  count = length(var.default_outbound_acl_rules)
  network_acl_id = aws_network_acl.private.id

  egress          = true
  rule_number     = var.default_outbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.default_outbound_acl_rules[count.index]["rule_action"]
  from_port       = lookup(var.default_outbound_acl_rules[count.index], "from_port", null)
  to_port         = lookup(var.default_outbound_acl_rules[count.index], "to_port", null)
  icmp_code       = lookup(var.default_outbound_acl_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.default_outbound_acl_rules[count.index], "icmp_type", null)
  protocol        = var.default_outbound_acl_rules[count.index]["protocol"]
  cidr_block      = lookup(var.default_outbound_acl_rules[count.index], "cidr_block", null)
  ipv6_cidr_block = lookup(var.default_outbound_acl_rules[count.index], "ipv6_cidr_block", null)
}

#DATA ACL

resource "aws_network_acl" "data" {
  vpc_id = aws_vpc.main.id
  subnet_ids = aws_subnet.data[*].id

  tags = {
    Name = "${var.environment}-data-nacl"
  }
}

resource "aws_network_acl_rule" "data_inbound" {

  count = length(var.data_inbound_acl_rules)
  network_acl_id = aws_network_acl.data.id

  egress          = false
  rule_number     = var.data_inbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.data_inbound_acl_rules[count.index]["rule_action"]
  from_port       = lookup(var.data_inbound_acl_rules[count.index], "from_port", null)
  to_port         = lookup(var.data_inbound_acl_rules[count.index], "to_port", null)
  icmp_code       = lookup(var.data_inbound_acl_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.data_inbound_acl_rules[count.index], "icmp_type", null)
  protocol        = var.data_inbound_acl_rules[count.index]["protocol"]
  cidr_block      = lookup(var.data_inbound_acl_rules[count.index], "cidr_block", null)
  ipv6_cidr_block = lookup(var.data_inbound_acl_rules[count.index], "ipv6_cidr_block", null)
}


resource "aws_network_acl_rule" "data_outbound" {

  count = length(var.default_outbound_acl_rules)
  network_acl_id = aws_network_acl.data.id

  egress          = true
  rule_number     = var.default_outbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.default_outbound_acl_rules[count.index]["rule_action"]
  from_port       = lookup(var.default_outbound_acl_rules[count.index], "from_port", null)
  to_port         = lookup(var.default_outbound_acl_rules[count.index], "to_port", null)
  icmp_code       = lookup(var.default_outbound_acl_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.default_outbound_acl_rules[count.index], "icmp_type", null)
  protocol        = var.default_outbound_acl_rules[count.index]["protocol"]
  cidr_block      = lookup(var.default_outbound_acl_rules[count.index], "cidr_block", null)
  ipv6_cidr_block = lookup(var.default_outbound_acl_rules[count.index], "ipv6_cidr_block", null)
}