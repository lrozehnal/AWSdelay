data "aws_availability_zones" "zones" {
   provider = aws
}

locals{
  subnet_splits = var.use_6_AZs ? [3, 3, 3, 3, 3, 3] : [2, 2, 2]
} 

resource "aws_subnet" "subnets" {
  count = length (data.aws_availability_zones.zones.zone_ids)
  provider         = aws
  vpc_id            = aws_vpc.vpc.id

  #cidr_block = cidrsubnets(var.cidr, var.use_6_AZs ? [3, 3, 3, 3, 3, 3] : [2, 2, 2]) [count.index]
  # The above line is replaced by the following to avoid a bug in Terraform 1.5.0

  cidr_block        = cidrsubnets(var.cidr, local.subnet_splits...)[count.index]
  availability_zone = data.aws_availability_zones.zones.names[count.index]  
  tags = merge(var.tags, {
    Name = var.name
  })
}
