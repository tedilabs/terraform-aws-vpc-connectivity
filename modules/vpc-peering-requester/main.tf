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
data "aws_region" "this" {
  region = var.region
}

locals {
  requester = {
    vpc     = var.requester.vpc
    region  = data.aws_region.this.region
    account = data.aws_caller_identity.this.account_id
  }
  accepter = {
    vpc     = var.accepter.vpc
    region  = coalesce(var.accepter.region, local.requester.region)
    account = coalesce(var.accepter.account, local.requester.account)
  }
}


###################################################
# VPC Peering for Requester
###################################################

# INFO: Not supported attributes
# - `accepter`
# - `requester`
resource "aws_vpc_peering_connection" "this" {
  region = var.region

  vpc_id      = local.requester.vpc
  auto_accept = local.requester.account == local.accepter.account && local.requester.region == local.accepter.region

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
resource "aws_vpc_peering_connection_options" "this" {
  count = var.allow_remote_vpc_dns_resolution ? 1 : 0

  region = var.region

  vpc_peering_connection_id = aws_vpc_peering_connection.this.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

data "aws_vpc_peering_connection" "this" {
  # INFO: To be implemented
  # INFO: https://github.com/hashicorp/terraform-provider-aws/issues/42463
  # region = var.region

  id = aws_vpc_peering_connection.this.id
}
