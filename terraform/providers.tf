terraform {
  required_providers {
    aws = {}
  }
  backend "s3" {
    bucket = "ludek-terraform-states-buckets"
    key    = "AWSdelay/terraform.tfstate"
    region = "eu-west-1"
    #    dynamodb_table = "use_lockfile"
  }
}

provider "aws" {
  alias  = "eu-west-1"
  region = "eu-west-1"
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "us-west-1"
  region = "us-west-1"
}

provider "aws" {
  alias  = "ap-southeast-1"
  region = "ap-southeast-1"
}

provider "aws" {
  alias  = "ap-southeast-2"
  region = "ap-southeast-2"
}
/*
*/