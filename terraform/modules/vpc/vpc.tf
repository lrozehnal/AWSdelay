resource "aws_vpc" "vpc" {
  provider         =  aws
  cidr_block       = var.cidr
  instance_tenancy = "default"
  enable_dns_hostnames =  "true"
  tags = merge(var.tags, {
    Name = var.name
  })
}