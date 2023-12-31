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

data "aws_caller_identity" "this" {}
data "aws_region" "this" {}

data "aws_vpc_peering_connection" "this" {
  id = var.peering_connection.id

  vpc_id     = var.peering_connection.requester_vpc.id
  region     = var.peering_connection.requester_vpc.region
  owner_id   = var.peering_connection.requester_vpc.account
  cidr_block = var.peering_connection.requester_vpc.ipv4_cidr

  peer_vpc_id     = var.peering_connection.accepter_vpc.id
  peer_region     = data.aws_region.this.name
  peer_owner_id   = data.aws_caller_identity.this.account_id
  peer_cidr_block = var.peering_connection.accepter_vpc.ipv4_cidr
}

locals {
  requester_vpc = {
    account = data.aws_vpc_peering_connection.this.owner_id
    region  = data.aws_vpc_peering_connection.this.region
    id      = aws_vpc_peering_connection_accepter.this.vpc_id
    ipv4_cidrs = [
      for cidr in data.aws_vpc_peering_connection.this.cidr_block_set :
      cidr.cidr_block
    ]
  }
  accepter_vpc = {
    account = aws_vpc_peering_connection_accepter.this.peer_owner_id
    region  = aws_vpc_peering_connection_accepter.this.peer_region
    id      = aws_vpc_peering_connection_accepter.this.peer_vpc_id
    ipv4_cidrs = [
      for cidr in data.aws_vpc_peering_connection.this.peer_cidr_block_set :
      cidr.cidr_block
    ]
  }
}


###################################################
# VPC Peering for Accepter
###################################################

resource "aws_vpc_peering_connection_accepter" "this" {
  vpc_peering_connection_id = data.aws_vpc_peering_connection.this.id
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
resource "aws_vpc_peering_connection_options" "this" {
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.this.id

  accepter {
    allow_remote_vpc_dns_resolution = var.allow_remote_vpc_dns_resolution
  }
}
