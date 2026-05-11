
/* THIS IS IGNORED IN THIS MODULE AS I AM NOT LOOKING UP EXISTING TGWS, I AM CONFIGURING THOSE LATER SOMEWHERE ELSE

data "aws_ec2_transit_gateway" "tgw" {
  provider = aws
  filter {
    name = "options.amazon-side-asn"
    values = ["64991","64992","64993","64994","64995","64996","64997","64998"]
  }
 */
  #/*
  #filter {
  #  name   = "owner-id "
  #  values = [local.connectivity_aws_account_id,"xxx"]
  #}
  #*/

/*
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_vpc_attachement" {
  provider = aws
  subnet_ids         = aws_subnet.subnets[*].id
  transit_gateway_id = data.aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.vpc.id
  tags = merge(var.tags, {
    Name = var.name
  })
}


resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "accept" {
  provider = aws
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tgw_vpc_attachement.id
  tags = merge(var.tags, {
    Name = var.name
  })
}
*/