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
# Service for VPC Lattice
###################################################

data "aws_vpclattice_service" "this" {
  name = var.name
}


###################################################
# Service Network Associations of Service
###################################################

resource "aws_vpclattice_service_network_service_association" "this" {
  for_each = {
    for association in var.service_network_associations :
    association.name => association
  }

  service_identifier = data.aws_vpclattice_service.this.id

  service_network_identifier = each.value.service_network

  tags = merge(
    {
      "Name" = "${each.key}/${var.name}"
    },
    local.module_tags,
    var.tags,
    each.value.tags,
  )
}
