resource "aws_route_table" "route_table" {
  provider         = aws
  vpc_id   = aws_vpc.vpc.id
  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_route_table_association" "route_table_subnet_association" {
  provider         = aws
  count = length (data.aws_availability_zones.zones.zone_ids)
  subnet_id      = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.route_table.id
}

/*

resource "aws_route" "default_route" {
  provider         = aws
  route_table_id = aws_route_table.route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  transit_gateway_id = data.aws_ec2_transit_gateway.tgw.id
}
*/