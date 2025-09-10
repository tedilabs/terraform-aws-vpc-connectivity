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

locals {
  requester_vpc = {
    id      = var.requester_vpc.id
    region  = data.aws_region.this.region
    account = data.aws_caller_identity.this.account_id
  }
  accepter_vpc = {
    id      = var.accepter_vpc.id
    region  = coalesce(var.accepter_vpc.region, local.requester_vpc.region)
    account = coalesce(var.accepter_vpc.account, local.requester_vpc.account)
  }
}


###################################################
# VPC Peering for Requester
###################################################

# INFO: Not supported attributes
# - `accepter`
# - `requester`
resource "aws_vpc_peering_connection" "this" {
  vpc_id      = local.requester_vpc.id
  auto_accept = false

  peer_vpc_id   = local.accepter_vpc.id
  peer_region   = local.accepter_vpc.region
  peer_owner_id = local.accepter_vpc.account

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
resource "aws_vpc_peering_connection_options" "this" {
  count = var.allow_remote_vpc_dns_resolution ? 1 : 0

  vpc_peering_connection_id = aws_vpc_peering_connection.this.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

data "aws_vpc_peering_connection" "this" {
  id = aws_vpc_peering_connection.this.id
}
