## there are going to be two ec2 instaces - one in 'client' VPC to test from and other in 'server' VPC to test against (this EC2 will be hiden behind those four endpoints in differenct regions)
/**/
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "aws_key_pair" "key" {
  provider   = aws.eu-west-1
  key_name   = "ec2key for AWSdelay"
  public_key = tls_private_key.key.public_key_openssh
  tags = merge(local.tags, {
    Name = "EC2 key for AWSdelay"
  })
}


resource "aws_ssm_parameter" "ec2_private_key" {
  name   = "/ec2/my-key/private-key-for-AWSdelay"
  type   = "SecureString"
  value  = tls_private_key.key.private_key_pem
  key_id = "alias/aws/ssm"
  tags = merge(local.tags, {
    Name = "EC2 key"
  })
}


module "client-ec2" {
  source     = "./modules/ec2"
  key_name   = "ec2key for AWSdelay"
  public_key = tls_private_key.key.public_key_openssh
  vpc_id     = module.aws_vpc_client.vpc_id
  subnets_id = module.aws_vpc_client.subnets_id
  name       = "client"
  domain     = "mplexia.com"
  tags       = local.tags
  providers = {
    aws = aws.ap-southeast-2
  }
}

module "server-ec2" {
  source     = "./modules/ec2"
  key_name   = "ec2key for AWSdelay"
  public_key = tls_private_key.key.public_key_openssh
  vpc_id     = module.aws_vpc_server.vpc_id
  subnets_id = module.aws_vpc_server.subnets_id
  name       = "server"
  domain     = "mplexia.com"
  tags       = local.tags
  providers = {
    aws = aws.us-east-1
  }
}

