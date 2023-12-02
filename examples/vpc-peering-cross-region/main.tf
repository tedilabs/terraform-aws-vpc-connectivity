provider "aws" {
  alias = "use1"

  region = "us-east-1"
}

provider "aws" {
  alias = "apne2"

  region = "ap-northeast-2"
}

resource "aws_vpc" "use1" {
  provider = aws.use1

  cidr_block = "10.1.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "Name" = "use1"
  }
}

resource "aws_vpc" "apne2" {
  provider = aws.apne2

  cidr_block = "10.2.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "Name" = "apne2"
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
    aws.requester = aws.use1
    aws.accepter  = aws.apne2
  }

  name = "use1/apne2"


  ## Requester
  requester_vpc = {
    id = aws_vpc.use1.id
  }
  requester_options = {
    allow_remote_vpc_dns_resolution = true
  }


  ## Acccepter
  accepter_vpc = {
    id = aws_vpc.apne2.id
  }
  accepter_options = {
    allow_remote_vpc_dns_resolution = true
  }


  tags = {
    "project" = "terraform-aws-vpc-connectivity-examples"
  }
}
