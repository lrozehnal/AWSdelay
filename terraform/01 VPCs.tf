module "aws_vpc_flowlogs" {
  source = "./modules/flowlogs"
  providers = {
    aws = aws.eu-west-1
  }
  tags = local.tags
}

module "aws_vpc_client" {
  source = "./modules/vpc"
  providers = {
    aws = aws.ap-southeast-2
  }
  cidr             = local.aws_config_env.vpc.client.cidr
  desc             = local.aws_config_env.vpc.client.desc
  tags             = local.tags
  name             = local.aws_config_env.vpc.client.name
  is_public        = true
  flowlog_iam_role = module.aws_vpc_flowlogs.aws_iam_role_arn
}

module "aws_vpc_server" {
  source = "./modules/vpc"
  providers = {
    aws = aws.us-east-1
  }
  cidr             = local.aws_config_env.vpc.server.cidr
  desc             = local.aws_config_env.vpc.client.desc
  tags             = local.tags
  name             = local.aws_config_env.vpc.server.name
  use_6_AZs        = true
  is_public        = true
  flowlog_iam_role = module.aws_vpc_flowlogs.aws_iam_role_arn
}


module "aws_vpc_proxy-1" {
  source = "./modules/vpc"
  providers = {
    aws = aws.ap-southeast-2
  }
  cidr             = local.aws_config_env.vpc.proxy-1.cidr
  desc             = local.aws_config_env.vpc.proxy-1.desc
  tags             = local.tags
  name             = local.aws_config_env.vpc.proxy-1.name
  flowlog_iam_role = module.aws_vpc_flowlogs.aws_iam_role_arn
}

module "aws_vpc_proxy-2" {
  source = "./modules/vpc"
  providers = {
    aws = aws.ap-southeast-1
  }
  cidr             = local.aws_config_env.vpc.proxy-2.cidr
  desc             = local.aws_config_env.vpc.proxy-2.desc
  tags             = local.tags
  name             = local.aws_config_env.vpc.proxy-2.name
  flowlog_iam_role = module.aws_vpc_flowlogs.aws_iam_role_arn
}
module "aws_vpc_proxy-3" {
  source = "./modules/vpc"
  providers = {
    aws = aws.us-west-1
  }
  cidr             = local.aws_config_env.vpc.proxy-3.cidr
  desc             = local.aws_config_env.vpc.proxy-3.desc
  tags             = local.tags
  name             = local.aws_config_env.vpc.proxy-3.name
  flowlog_iam_role = module.aws_vpc_flowlogs.aws_iam_role_arn
}

module "aws_vpc_proxy-4" {
  source = "./modules/vpc"
  providers = {
    aws = aws.us-east-1
  }
  cidr             = local.aws_config_env.vpc.proxy-4.cidr
  desc             = local.aws_config_env.vpc.proxy-4.desc
  tags             = local.tags
  name             = local.aws_config_env.vpc.proxy-4.name
  use_6_AZs        = true
  flowlog_iam_role = module.aws_vpc_flowlogs.aws_iam_role_arn
}
