provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "one" {
  cidr_block = "10.1.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "Name" = "one"
  }
}

resource "aws_vpc" "two" {
  cidr_block = "10.2.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "Name" = "two"
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

  name = "one/two"


  ## Requester
  requester_vpc = {
    id = aws_vpc.one.id
  }
  requester_options = {
    allow_remote_vpc_dns_resolution = true
  }


  ## Acccepter
  accepter_vpc = {
    id = aws_vpc.two.id
  }
  accepter_options = {
    allow_remote_vpc_dns_resolution = true
  }


  tags = {
    "project" = "terraform-aws-vpc-connectivity-examples"
  }
}
