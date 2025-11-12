locals {
  metadata = {
    package = "terraform-aws-vpc-connectivity"
    version = trimspace(file("${path.module}/../../VERSION"))
    module  = basename(path.module)
    name    = var.name
  }
  module_tags = var.module_tags_enabled ? {
    "module.terraform.io/package"   = local.metadata.package
    "module.terraform.io/version"   = local.metadata.version
    "module.terraform.io/name"      = local.metadata.module
    "module.terraform.io/full-name" = "${local.metadata.package}/${local.metadata.module}"
    "module.terraform.io/instance"  = local.metadata.name
  } : {}
}

provider "aws" {
  alias = "requester"
}

provider "aws" {
  alias = "accepter"
}

data "aws_caller_identity" "requester" {
  provider = aws.requester
}

data "aws_caller_identity" "accepter" {
  provider = aws.accepter
}

data "aws_region" "requester" {
  provider = aws.requester

  region = var.requester.region
}

data "aws_region" "accepter" {
  provider = aws.accepter

  region = var.accepter.region
}

locals {
  requester = {
    vpc     = var.requester.vpc
    region  = data.aws_region.requester.region
    account = data.aws_caller_identity.requester.account_id
  }
  accepter = {
    vpc     = var.accepter.vpc
    region  = data.aws_region.accepter.region
    account = data.aws_caller_identity.accepter.account_id
  }
}


###################################################
# VPC Peering for Requester
###################################################

# INFO: Not supported attributes
# - `accepter`
# - `requester`
resource "aws_vpc_peering_connection" "this" {
  provider = aws.requester

  region = local.requester.region

  vpc_id      = local.requester.vpc
  auto_accept = false

  peer_vpc_id   = local.accepter.vpc
  peer_region   = local.accepter.region
  peer_owner_id = local.accepter.account

  tags = merge(
    {
      "Name" = local.metadata.name
    },
    local.module_tags,
    var.tags,
  )
}

# INFO: Not supported attributes
# - `accepter`
resource "aws_vpc_peering_connection_options" "requester" {
  provider = aws.requester

  region = local.requester.region

  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.this.id

  requester {
    allow_remote_vpc_dns_resolution = var.requester_options.allow_remote_vpc_dns_resolution
  }
}


###################################################
# VPC Peering for Accepter
###################################################

resource "aws_vpc_peering_connection_accepter" "this" {
  provider = aws.accepter

  region = local.accepter.region

  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
  auto_accept               = true

  tags = merge(
    {
      "Name" = local.metadata.name
    },
    local.module_tags,
    var.tags,
  )
}

# INFO: Not supported attributes
# - `requester`
resource "aws_vpc_peering_connection_options" "accepter" {
  provider = aws.accepter

  region = local.accepter.region

  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.this.id

  accepter {
    allow_remote_vpc_dns_resolution = var.accepter_options.allow_remote_vpc_dns_resolution
  }
}

data "aws_vpc_peering_connection" "this" {
  provider = aws.accepter

  # INFO: To be implemented
  # INFO: https://github.com/hashicorp/terraform-provider-aws/issues/42463
  # region = var.region

  id = aws_vpc_peering_connection_accepter.this.id
}
