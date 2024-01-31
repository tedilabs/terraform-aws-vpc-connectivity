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


###################################################
# Transit Gateway
###################################################

resource "aws_ec2_transit_gateway" "this" {
  description                 = var.description
  amazon_side_asn             = var.asn
  transit_gateway_cidr_blocks = var.cidr_blocks


  ## Default Route Tables
  default_route_table_association = var.default_association_route_table.enabled ? "enable" : "disable"
  default_route_table_propagation = var.default_propagation_route_table.enabled ? "enable" : "disable"


  ## Attributes
  dns_support                    = var.dns_support_enabled ? "enable" : "disable"
  vpn_ecmp_support               = var.vpn_ecmp_support_enabled ? "enable" : "disable"
  multicast_support              = var.multicast_support_enabled ? "enable" : "disable"
  auto_accept_shared_attachments = var.auto_accept_cross_account_attachments ? "enable" : "disable"

  tags = merge(
    {
      "Name" = local.metadata.name
    },
    local.module_tags,
    var.tags,
  )
}
