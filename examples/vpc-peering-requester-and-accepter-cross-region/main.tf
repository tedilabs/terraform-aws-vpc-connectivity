provider "aws" {
  alias = "use1"

  region = "us-east-1"
}

provider "aws" {
  alias = "apne2"

  region = "ap-northeast-2"
}

data "aws_vpc" "use1" {
  provider = aws.use1

  default = true
}

resource "aws_vpc" "apne2" {
  provider = aws.apne2

  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "apne2"
  }
}


###################################################
# Requester for VPC Peering
###################################################

module "requester" {
  source = "../../modules/vpc-peering-requester"
  # source  = "tedilabs/vpc-connectivity/aws//modules/vpc-peering-requester"
  # version = "~> 0.2.0"

  providers = {
    aws = aws.use1
  }

  name = "use1/apne2"

  requester_vpc = {
    id = data.aws_vpc.use1.id
  }
  accepter_vpc = {
    id     = aws_vpc.apne2.id
    region = "ap-northeast-2"
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

  providers = {
    aws = aws.apne2
  }

  name = "use1/apne2"

  peering_connection = {
    id = module.requester.id
  }

  allow_remote_vpc_dns_resolution = false

  tags = {
    "project" = "terraform-aws-vpc-connectivity-examples"
  }
}
