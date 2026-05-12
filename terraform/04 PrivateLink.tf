
module "privatelink_us-east-1" {
  tags   = local.tags
  source = "./modules/privatelink"
  providers = {
    aws.client = aws.ap-southeast-2,
    aws.nlb    = aws.us-east-1
  }
  tg_port       = 5201                                                                                                                             
  listener_port = 5201
  target_ip     = module.server-ec2.ec2_private_ip
  nlbregion          = "us-east-1"
  vpc_id        = module.aws_vpc_proxy-4.vpc_id
  subnets_id    = module.aws_vpc_proxy-4.subnets_id
  client_vpc_id = module.aws_vpc_client.vpc_id
  client_subnets_id = module.aws_vpc_client.subnets_id
  name = "proxy-4"
  domain     = "mplexia.com"
}


module "privatelink_us-west-1" {
  tags   = local.tags
  source = "./modules/privatelink"
  providers = {
    aws.client = aws.ap-southeast-2,
    aws.nlb    = aws.us-west-1
  }
  tg_port       = 5201                                                                                                                             
  listener_port = 5201
  target_ip     = module.server-ec2.ec2_private_ip
  nlbregion          = "us-west-1"
  vpc_id        = module.aws_vpc_proxy-3.vpc_id
  subnets_id    = module.aws_vpc_proxy-3.subnets_id
  client_vpc_id = module.aws_vpc_client.vpc_id
  client_subnets_id = module.aws_vpc_client.subnets_id
  name = "proxy-3"
  domain     = "mplexia.com"
}

module "privatelink_ap-southeast-1" {
  tags   = local.tags
  source = "./modules/privatelink"
  providers = {
    aws.client = aws.ap-southeast-2,
    aws.nlb    = aws.ap-southeast-1
  }
  tg_port       = 5201                                                                                                                             
  listener_port = 5201
  target_ip     = module.server-ec2.ec2_private_ip
  nlbregion          = "ap-southeast-1"
  vpc_id        = module.aws_vpc_proxy-2.vpc_id
  subnets_id    = module.aws_vpc_proxy-2.subnets_id
  client_vpc_id = module.aws_vpc_client.vpc_id
  client_subnets_id = module.aws_vpc_client.subnets_id
  name = "proxy-2"
  domain     = "mplexia.com"
}

module "privatelink_ap-southeast-2" {
  tags   = local.tags
  source = "./modules/privatelink"
  providers = {
    aws.client = aws.ap-southeast-2,
    aws.nlb    = aws.ap-southeast-2
  }
  tg_port       = 5201                                                                                                                             
  listener_port = 5201
  target_ip     = module.server-ec2.ec2_private_ip
  nlbregion          = "ap-southeast-2"
  vpc_id        = module.aws_vpc_proxy-1.vpc_id
  subnets_id    = module.aws_vpc_proxy-1.subnets_id
  client_vpc_id = module.aws_vpc_client.vpc_id
  client_subnets_id = module.aws_vpc_client.subnets_id
  name = "proxy-1"
  domain     = "mplexia.com"
}
/**/