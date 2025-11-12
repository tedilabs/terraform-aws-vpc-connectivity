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

  name = "two"
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
# Requester for VPC Peering
###################################################

module "requester" {
  source = "../../modules/vpc-peering-requester"
  # source  = "tedilabs/vpc-connectivity/aws//modules/vpc-peering-requester"
  # version = "~> 0.2.0"

  name = "one/two"

  requester = {
    vpc = module.vpc_one.id
  }
  accepter = {
    vpc = module.vpc_two.id
  }

  allow_remote_vpc_dns_resolution = false

  tags = {
    "project" = "terraform-aws-vpc-connectivity-examples"
  }
}


###################################################
# Accepter for VPC Peering
###################################################

module "accepter" {
  source = "../../modules/vpc-peering-accepter"
  # source  = "tedilabs/vpc-connectivity/aws//modules/vpc-peering-accepter"
  # version = "~> 0.2.0"

  name = "one/two"

  peering_connection = {
    id = module.requester.id
  }

  allow_remote_vpc_dns_resolution = false

  tags = {
    "project" = "terraform-aws-vpc-connectivity-examples"
  }
}
