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
# Transit Gateway
###################################################

module "transit_gateway" {
  source = "../../modules/transit-gateway"
  # source  = "tedilabs/vpc-connectivity/aws//modules/transit-gateway"
  # version = "~> 0.2.0"

  name        = "test"
  description = "Managed by Terraform."


  ## Routes
  default_association_route_table = {
    enabled = false
  }
  default_propagation_route_table = {
    enabled = false
  }


  ## Attributes
  dns_support_enabled                   = true
  multicast_support_enabled             = false
  vpn_ecmp_support_enabled              = true
  auto_accept_cross_account_attachments = true


  tags = {
    "project" = "terraform-aws-vpc-connectivity-examples"
  }
}


###################################################
# Transit Gateway Route Tables
###################################################

module "route_table" {
  source = "../../modules/transit-gateway-route-table"
  # source  = "tedilabs/vpc-connectivity/aws//modules/transit-gateway-route-table"
  # version = "~> 0.2.0"

  transit_gateway = module.transit_gateway.id

  name = "center"


  tags = {
    "project" = "terraform-aws-vpc-connectivity-examples"
  }
}
