provider "aws" {
  region = "us-east-1"
}

module "vpc_one" {
  source = "tedilabs/network/aws//modules/vpc"

  name = "one"
  ipv4_cidrs = [
    {
      type = "MANUAL"
      cidr = "10.1.0.0/16"
    }
  ]

  dns_hostnames_enabled = true
  route53_resolver = {
    enabled = true
  }
}

module "vpc_two" {
  source = "tedilabs/network/aws//modules/vpc"

  region = "ap-northeast-2"
  name   = "two"
  ipv4_cidrs = [
    {
      type = "MANUAL"
      cidr = "10.2.0.0/16"
    }
  ]

  dns_hostnames_enabled = true
  route53_resolver = {
    enabled = true
  }
}


###################################################
# VPC Peering
###################################################

module "peering" {
  source = "../../modules/vpc-peering"
  # source  = "tedilabs/vpc-connectivity/aws//modules/vpc-peering"
  # version = "~> 0.2.0"

  providers = {
    aws.requester = aws
    aws.accepter  = aws
  }

  name = "use1/apne2"


  ## Requester
  requester = {
    vpc = module.vpc_one.id
  }
  requester_options = {
    allow_remote_vpc_dns_resolution = true
  }


  ## Acccepter
  accepter = {
    vpc    = module.vpc_two.id
    region = "ap-northeast-2"
  }
  accepter_options = {
    allow_remote_vpc_dns_resolution = true
  }


  tags = {
    "project" = "terraform-aws-vpc-connectivity-examples"
  }
}
