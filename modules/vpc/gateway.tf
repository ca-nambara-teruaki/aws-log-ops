# internet gateway
resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.env_name}-${var.sys_name}-igw"
    Env  = var.env_name
  }
}

# Elastic IP for each NAT gateway on each availability zone.
resource "aws_eip" "nat" {
  for_each = var.public_subnet_config

  tags = {
    Name = "${var.env_name}-${var.sys_name}-${each.value.az}-ngw-eip"
    Env  = var.env_name
  }
}

# NAT gateway for each front subnet on each availability zone.
resource "aws_nat_gateway" "nat_gateway" {
  for_each = var.public_subnet_config

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public_subnet[each.key].id

  tags = {
    Name = "${var.env_name}-${var.sys_name}-${each.value.az}-ngw"
    Env  = var.env_name
  }

  depends_on = [
    aws_eip.nat,
    aws_subnet.public_subnet,
  ]
}
