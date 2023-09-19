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
# Service Network for VPC Lattice
###################################################

resource "aws_vpclattice_service_network" "this" {
  name      = var.name
  auth_type = var.auth_type

  tags = merge(
    {
      "Name" = local.metadata.name
    },
    local.module_tags,
    var.tags,
  )
}


###################################################
# VPC Associations of Service Network
###################################################

resource "aws_vpclattice_service_network_vpc_association" "this" {
  for_each = {
    for association in var.vpc_associations :
    association.vpc => association
  }

  service_network_identifier = aws_vpclattice_service_network.this.id

  vpc_identifier     = each.key
  security_group_ids = each.value.security_groups

  tags = merge(
    {
      "Name" = "${var.name}/${each.key}"
    },
    local.module_tags,
    var.tags,
    each.value.tags,
  )
}


###################################################
# Service Associations of Service Network
###################################################

resource "aws_vpclattice_service_network_service_association" "this" {
  for_each = {
    for association in var.service_associations :
    association.name => association
  }

  service_network_identifier = aws_vpclattice_service_network.this.id

  service_identifier = each.value.service

  tags = merge(
    {
      "Name" = "${var.name}/${each.key}"
    },
    local.module_tags,
    var.tags,
    each.value.tags,
  )
}
