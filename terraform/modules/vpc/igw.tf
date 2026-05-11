resource "aws_internet_gateway" "igw" {
  count = var.is_public ? 1 : 0
  provider         = aws
  vpc_id = aws_vpc.vpc.id
  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_route" "default_route_via_igw" {
  count = var.is_public ? 1 : 0
  provider         = aws
  route_table_id = aws_route_table.route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw[0].id 
}