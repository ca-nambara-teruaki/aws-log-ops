# ---------------------------------------------------------
# vpc
# ---------------------------------------------------------
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name = "${var.env_name}-${var.sys_name}-vpc"
    Env  = var.env_name
  }
}

# ---------------------------------------------------------
# public subnet
# ---------------------------------------------------------
resource "aws_subnet" "public_subnet" {
  for_each = var.public_subnet_config

  vpc_id            = aws_vpc.vpc.id
  availability_zone = each.value.az
  cidr_block        = each.value.cidr
  tags = {
    Name = "${var.env_name}-${var.sys_name}-public-subnet-${each.value.az}"
    Env  = var.env_name
  }
}

resource "aws_route_table" "public_rtb" {
  for_each = var.public_subnet_config

  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.env_name}-${var.sys_name}-public-rtb-${each.value.az}"
    Env  = var.env_name
  }
}

resource "aws_route" "public_rt_route" {
  for_each = var.public_subnet_config

  route_table_id         = aws_route_table.public_rtb[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc_igw.id
  depends_on             = [aws_route_table.public_rtb, aws_internet_gateway.vpc_igw]
}

resource "aws_route_table_association" "public-rt-association" {
  for_each = var.public_subnet_config

  subnet_id      = aws_subnet.public_subnet[each.key].id
  route_table_id = aws_route_table.public_rtb[each.key].id
}

# ---------------------------------------------------------
# private subnet
# ---------------------------------------------------------
resource "aws_subnet" "private_subnet" {
  for_each = var.private_subnet_config

  vpc_id            = aws_vpc.vpc.id
  availability_zone = each.value.az
  cidr_block        = each.value.cidr
  tags = {
    Name = "${var.env_name}-${var.sys_name}-private-subnet-${each.value.az}"
    Env  = var.env_name
  }
}

resource "aws_route_table" "private_rtb" {
  for_each = var.private_subnet_config

  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.env_name}-${var.sys_name}-private-rtb-${each.value.az}"
    Env  = var.env_name
  }
}

resource "aws_route" "private_rt_route" {
  for_each = var.private_subnet_config

  route_table_id         = aws_route_table.private_rtb[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway[each.key].id
  depends_on             = [aws_route_table.private_rtb, aws_nat_gateway.nat_gateway]
}

resource "aws_route_table_association" "private-rt-association" {
  for_each = var.private_subnet_config

  subnet_id      = aws_subnet.private_subnet[each.key].id
  route_table_id = aws_route_table.private_rtb[each.key].id
}
