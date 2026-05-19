# This here is suppposed to connect the client VPC with TGW (in ap-southeast-2) to allow me direct TCP tests between client box and server box without using any Endpoint so I have a base line
# I need to come up with some 'proper' heavy testing - I am really curious if those endpoint can 'improve'  the general statistic - especially for 'heavy loads' - the AWS backbone is not without packet drops , right?




## ATTACH client VPC to TGWs in ap-southeast-2 -  this is for testing purposes only - to have a direct connection between client and server VPCs without using any Endpoints - to have a base line for testing the performance of Endpoints

resource "aws_ec2_transit_gateway_vpc_attachment" "ap-southeast-2-vpc-client-attachment" {
  provider           = aws.ap-southeast-2
  transit_gateway_id = aws_ec2_transit_gateway.ap-southeast-2-TGW.id
  vpc_id             = module.aws_vpc_client.vpc_id
  subnet_ids         = module.aws_vpc_client.subnets_id
  dns_support  = "enable" # Optional                                                                                                                                                                                                                                                     
  ipv6_support = "disable"
  tags = merge(local.tags, {
    Name = "VPC attachment in ap-southeast-2 for client VPC"
  })
}

## routing  - in client VPC , I need to route server VPC CIDR via ap-southeast-2 TGW, then in server VPC, I need to add route for client VPC via us-east-1 TGW, and finally on us-east-1 TGW, I need to add the route for client VPC via TGW peering with ap-southeast-2 TGW ;) 

### routess inside VPCs:


resource "aws_route" "server_vpc_specific-5" {
  provider               = aws.us-east-1
  route_table_id         = module.aws_vpc_server.route_table_id
  destination_cidr_block = local.aws_config_env.vpc.client.cidr
  transit_gateway_id     = aws_ec2_transit_gateway.us-east-1-TGW.id
}

resource "aws_route" "client-1_vpc" {
  provider               = aws.ap-southeast-2
  route_table_id         = module.aws_vpc_client.route_table_id
  destination_cidr_block = local.aws_config_env.vpc.server.cidr
  transit_gateway_id     = aws_ec2_transit_gateway.ap-southeast-2-TGW.id
}

### TGW routing

resource "aws_ec2_transit_gateway_route" "us-east-1-TGW-routes-for-peering-with-ap-southeast-2-second" {
  provider                       = aws.us-east-1
  destination_cidr_block         = local.aws_config_env.vpc.client.cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.ap-southeast-2-to-us-east-1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.us-east-1-TGW.association_default_route_table_id
}