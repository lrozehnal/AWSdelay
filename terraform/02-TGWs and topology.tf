## DEFINE 4 TGW
resource "aws_ec2_transit_gateway" "us-east-1-TGW" {
  provider        = aws.us-east-1
  description     = "eu-east-1 TGW"
  amazon_side_asn = "64994"
  tags = merge(local.tags, {
    Name = "us-east-1 TGW"
  })
}

resource "aws_ec2_transit_gateway" "us-west-1-TGW" {
  provider        = aws.us-west-1
  description     = "us-west-1 TGW"
  amazon_side_asn = "64993"
  tags = merge(local.tags, {
    Name = "us-west-1 TGW"
  })
}

resource "aws_ec2_transit_gateway" "ap-southeast-1-TGW" {
  provider        = aws.ap-southeast-1
  description     = "ap-souhteast-1 TGW"
  amazon_side_asn = "64992"
  tags = merge(local.tags, {
    Name = "ap-souhteast-1 TGW"
  })
}

resource "aws_ec2_transit_gateway" "ap-southeast-2-TGW" {
  provider        = aws.ap-southeast-2
  description     = "ap-souhteast-2 TGW"
  amazon_side_asn = "64991"
  tags = merge(local.tags, {
    Name = "ap-souhteast-2 TGW"
  })
}

## LOOKUP THE DEFAULT ROUTE TABLES FOR THOSE TGWS

/*
data "aws_ec2_transit_gateway_route_tables" "us-east-1-TGW-default-route-table" {
  provider        = aws.us-east-1
  filter {
    name   = "transit-gateway-id"
    values = [aws_ec2_transit_gateway.us-east-1-TGW.id]
  }
}

import {
  provider        = aws.us-east-1
  to       = aws_ec2_transit_gateway_route_table.us-east-1-TGW-default-route-table
  id       = data.aws_ec2_transit_gateway_route_tables.us-east-1-TGW-default-route-table.ids[0]
}
*/
resource "aws_ec2_transit_gateway_route_table" "us-east-1-TGW-default-route-table" {
  transit_gateway_id = aws_ec2_transit_gateway.us-east-1-TGW.id
  provider        = aws.us-east-1
  tags = {
    Name = "us-east-1 TGW default route table "
  }
}
/*

data "aws_ec2_transit_gateway_route_tables" "us-west-1-TGW-default-route-table" {
  provider        = aws.us-west-1
  filter {
    name   = "transit-gateway-id"
    values = [aws_ec2_transit_gateway.us-west-1-TGW.id]
  }
}

import {
  provider        = aws.us-west-1
  to       = aws_ec2_transit_gateway_route_table.us-west-1-TGW-default-route-table
  id       = data.aws_ec2_transit_gateway_route_tables.us-west-1-TGW-default-route-table.ids[0]
}
*/
resource "aws_ec2_transit_gateway_route_table" "us-west-1-TGW-default-route-table" {
  transit_gateway_id = aws_ec2_transit_gateway.us-west-1-TGW.id
  provider        = aws.us-west-1
  tags = {
    Name = "us-west-1 TGW default route table "
  }
}
/*

data "aws_ec2_transit_gateway_route_tables" "ap-southeast-1-TGW-default-route-table" {
  provider        = aws.ap-southeast-1
  filter {
    name   = "transit-gateway-id"
    values = [aws_ec2_transit_gateway.ap-southeast-1-TGW.id]
  }
}

import {
  provider        = aws.ap-southeast-1
  to       = aws_ec2_transit_gateway_route_table.ap-southeast-1-TGW-default-route-table
  id       = data.aws_ec2_transit_gateway_route_tables.ap-southeast-1-TGW-default-route-table.ids[0]
}
*/
resource "aws_ec2_transit_gateway_route_table" "ap-southeast-1-TGW-default-route-table" {
  transit_gateway_id = aws_ec2_transit_gateway.ap-southeast-1-TGW.id
  provider        = aws.ap-southeast-1
  tags = {
    Name = "ap-southeast-1 TGW default route table "
  }
}
/*
data "aws_ec2_transit_gateway_route_tables" "ap-southeast-2-TGW-default-route-table" {
  provider        = aws.ap-southeast-2
  filter {
    name   = "transit-gateway-id"
    values = [aws_ec2_transit_gateway.ap-southeast-2-TGW.id]
  }
}

import {
  provider        = aws.ap-southeast-2
  to       = aws_ec2_transit_gateway_route_table.ap-southeast-2-TGW-default-route-table
  id       = data.aws_ec2_transit_gateway_route_tables.ap-southeast-2-TGW-default-route-table.ids[0]
}
*/
resource "aws_ec2_transit_gateway_route_table" "ap-southeast-2-TGW-default-route-table" {
  transit_gateway_id = aws_ec2_transit_gateway.ap-southeast-2-TGW.id
  provider        = aws.ap-southeast-2
  tags = {
    Name = "ap-southeast-2 TGW default route table "
  }
}

##  END OF LOOKUP THE DEFAULT ROUTE TABLES FOR THOSE TGWS



## ATTACH 3 TGWs with us-east-1 to create demanded topoogy
## us-west-1 to us-east-1

resource "aws_ec2_transit_gateway_peering_attachment" "us-west-1-to-us-east-1" {
  provider                = aws.us-west-1
  transit_gateway_id      = aws_ec2_transit_gateway.us-west-1-TGW.id
  peer_region             = "us-east-1"
  peer_transit_gateway_id = aws_ec2_transit_gateway.us-east-1-TGW.id
  tags = merge(local.tags, {
    Name = "TGW peering between us-west-1 and us-east-1 - requester"
  })
}
resource "aws_ec2_transit_gateway_peering_attachment_accepter" "us-west-1-to-us-east-1-accepter" {
  provider                      = aws.us-east-1
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.us-west-1-to-us-east-1.id
  tags = merge(local.tags, {
    Name = "TGW peering between us-west-1 and us-east-1 - accepter"
  })
}

resource "aws_ec2_transit_gateway_peering_attachment" "ap-southeast-1-to-us-east-1" {
  provider                = aws.ap-southeast-1
  transit_gateway_id      = aws_ec2_transit_gateway.ap-southeast-1-TGW.id
  peer_region             = "us-east-1"
  peer_transit_gateway_id = aws_ec2_transit_gateway.us-east-1-TGW.id
  tags = merge(local.tags, {
    Name = "TGW peering between ap-southeast-1 and us-east-1 - requester"
  })
}
resource "aws_ec2_transit_gateway_peering_attachment_accepter" "ap-southeast-1-to-us-east-1-accepter" {
  provider                      = aws.us-east-1
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.ap-southeast-1-to-us-east-1.id
  tags = merge(local.tags, {
    Name = "TGW peering between ap-southeast-1 and us-east-1 - accepter"
  })
}

resource "aws_ec2_transit_gateway_peering_attachment" "ap-southeast-2-to-us-east-1" {
  provider                = aws.ap-southeast-2
  transit_gateway_id      = aws_ec2_transit_gateway.ap-southeast-2-TGW.id
  peer_region             = "us-east-1"
  peer_transit_gateway_id = aws_ec2_transit_gateway.us-east-1-TGW.id
  tags = merge(local.tags, {
    Name = "TGW peering between ap-southeast-2 and us-east-1 - requester"
  })
}
resource "aws_ec2_transit_gateway_peering_attachment_accepter" "ap-southeast-2-to-us-east-1-accepter" {
  provider                      = aws.us-east-1
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.ap-southeast-2-to-us-east-1.id
  tags = merge(local.tags, {
    Name = "TGW peering between ap-southeast-2 and us-east-1 - accepter"
  })
}



## routing for TGW:

resource "aws_ec2_transit_gateway_route" "us-east-1-TGW-routes-for-peering-with-us-west-1" {
  provider                       = aws.us-east-1
  destination_cidr_block         = local.aws_config_env.vpc.proxy-3.cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.us-west-1-to-us-east-1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.us-east-1-TGW-default-route-table.id
}
resource "aws_ec2_transit_gateway_route" "us-west-1-TGW-routes-for-peering-with-us-east-1" {
  provider                       = aws.us-west-1
  destination_cidr_block         = local.aws_config_env.vpc.server.cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.us-west-1-to-us-east-1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.us-west-1-TGW-default-route-table.id
}

resource "aws_ec2_transit_gateway_route" "us-east-1-TGW-routes-for-peering-with-ap-southeast-1" {
  provider                       = aws.us-east-1
  destination_cidr_block         = local.aws_config_env.vpc.proxy-2.cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.ap-southeast-1-to-us-east-1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.us-east-1-TGW-default-route-table.id
}
resource "aws_ec2_transit_gateway_route" "ap-southeast-1-TGW-routes-for-peering-with-us-east-1" {
  provider                       = aws.ap-southeast-1
  destination_cidr_block         = local.aws_config_env.vpc.server.cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.ap-southeast-1-to-us-east-1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.ap-southeast-1-TGW-default-route-table.id
}

resource "aws_ec2_transit_gateway_route" "us-east-1-TGW-routes-for-peering-with-ap-southeast-2" {
  provider                       = aws.us-east-1
  destination_cidr_block         = local.aws_config_env.vpc.proxy-1.cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.ap-southeast-2-to-us-east-1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.us-east-1-TGW-default-route-table.id
}
resource "aws_ec2_transit_gateway_route" "ap-southeast-2-TGW-routes-for-peering-with-us-east-1" {
  provider                       = aws.ap-southeast-2
  destination_cidr_block         = local.aws_config_env.vpc.server.cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.ap-southeast-2-to-us-east-1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.ap-southeast-2-TGW-default-route-table.id

}



## ATTACH 5 VPCs to TGWs (all per regions, except for ap-southeast-2 )

resource "aws_ec2_transit_gateway_vpc_attachment" "us-east-1-vpc-server-attachment" {
  provider           = aws.us-east-1
  transit_gateway_id = aws_ec2_transit_gateway.us-east-1-TGW.id
  vpc_id             = module.aws_vpc_server.vpc_id
  subnet_ids         = module.aws_vpc_server.subnets_id
  dns_support  = "enable" # Optional                                                                                                                                                                                                                                                     
  ipv6_support = "disable"
  tags = merge(local.tags, {
    Name = "VPC attachment in us-east-1 for server VPC"
  })
}

resource "aws_ec2_transit_gateway_vpc_attachment" "us-east-1-vpc-proxy-4-attachment" {
  provider           = aws.us-east-1
  transit_gateway_id = aws_ec2_transit_gateway.us-east-1-TGW.id
  vpc_id             = module.aws_vpc_proxy-4.vpc_id
  subnet_ids         = module.aws_vpc_proxy-4.subnets_id
  dns_support  = "enable" # Optional                                                                                                                                                                                                                                                     
  ipv6_support = "disable"
  tags = merge(local.tags, {
    Name = "VPC attachment in us-east-1 for proxy-4 VPC"
  })
}

/**/


resource "aws_ec2_transit_gateway_vpc_attachment" "us-west-1-vpc-proxy-3-attachment" {
  provider           = aws.us-west-1
  transit_gateway_id = aws_ec2_transit_gateway.us-west-1-TGW.id
  vpc_id             = module.aws_vpc_proxy-3.vpc_id
  subnet_ids         = module.aws_vpc_proxy-3.subnets_id
  dns_support  = "enable" # Optional                                                                                                                                                                                                                                                     
  ipv6_support = "disable"
  tags = merge(local.tags, {
    Name = "VPC attachment in us-west-1 for proxy-3 VPC"
  })
}


resource "aws_ec2_transit_gateway_vpc_attachment" "ap-southeast-1-vpc-proxy-2-attachment" {
  provider           = aws.ap-southeast-1
  transit_gateway_id = aws_ec2_transit_gateway.ap-southeast-1-TGW.id
  vpc_id             = module.aws_vpc_proxy-2.vpc_id
  subnet_ids         = module.aws_vpc_proxy-2.subnets_id
  dns_support  = "enable" # Optional                                                                                                                                                                                                                                                     
  ipv6_support = "disable"
  tags = merge(local.tags, {
    Name = "VPC attachment in ap-southeast-1 for proxy-2 VPC"
  })
}


resource "aws_ec2_transit_gateway_vpc_attachment" "ap-southeast-2-vpc-proxy-1-attachment" {
  provider           = aws.ap-southeast-2
  transit_gateway_id = aws_ec2_transit_gateway.ap-southeast-2-TGW.id
  vpc_id             = module.aws_vpc_proxy-1.vpc_id
  subnet_ids         = module.aws_vpc_proxy-1.subnets_id
  dns_support  = "enable" # Optional                                                                                                                                                                                                                                                     
  ipv6_support = "disable"
  tags = merge(local.tags, {
    Name = "VPC attachment in ap-southeast-2 for proxy-1 VPC"
  })
}




## finally routes inside vpcs


resource "aws_route" "server_vpc_specific-1" {
  provider               = aws.us-east-1
  route_table_id         = module.aws_vpc_server.route_table_id
  destination_cidr_block = local.aws_config_env.vpc.proxy-1.cidr
  transit_gateway_id     = aws_ec2_transit_gateway.us-east-1-TGW.id
}

resource "aws_route" "server_vpc_specific-2" {
  provider               = aws.us-east-1
  route_table_id         = module.aws_vpc_server.route_table_id
  destination_cidr_block = local.aws_config_env.vpc.proxy-2.cidr
  transit_gateway_id     = aws_ec2_transit_gateway.us-east-1-TGW.id
}

resource "aws_route" "server_vpc_specific-3" {
  provider               = aws.us-east-1
  route_table_id         = module.aws_vpc_server.route_table_id
  destination_cidr_block = local.aws_config_env.vpc.proxy-3.cidr
  transit_gateway_id     = aws_ec2_transit_gateway.us-east-1-TGW.id
}

resource "aws_route" "server_vpc_specific-4" {
  provider               = aws.us-east-1
  route_table_id         = module.aws_vpc_server.route_table_id
  destination_cidr_block = local.aws_config_env.vpc.proxy-4.cidr
  transit_gateway_id     = aws_ec2_transit_gateway.us-east-1-TGW.id
}

resource "aws_route" "proxy-1_vpc" {
  provider               = aws.ap-southeast-2
  route_table_id         = module.aws_vpc_proxy-1.route_table_id
  destination_cidr_block = local.aws_config_env.vpc.server.cidr
  transit_gateway_id     = aws_ec2_transit_gateway.ap-southeast-2-TGW.id
}

resource "aws_route" "proxy-2_vpc" {
  provider               = aws.ap-southeast-1
  route_table_id         = module.aws_vpc_proxy-2.route_table_id
  destination_cidr_block = local.aws_config_env.vpc.server.cidr
  transit_gateway_id     = aws_ec2_transit_gateway.ap-southeast-1-TGW.id
}
resource "aws_route" "proxy-3_vpc" {
  provider               = aws.us-west-1
  route_table_id         = module.aws_vpc_proxy-3.route_table_id
  destination_cidr_block = local.aws_config_env.vpc.server.cidr
  transit_gateway_id     = aws_ec2_transit_gateway.us-west-1-TGW.id
}
resource "aws_route" "proxy-4_vpc" {
  provider               = aws.us-east-1
  route_table_id         = module.aws_vpc_proxy-4.route_table_id
  destination_cidr_block = local.aws_config_env.vpc.server.cidr
  transit_gateway_id     = aws_ec2_transit_gateway.us-east-1-TGW.id
}
