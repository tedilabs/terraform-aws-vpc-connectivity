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
# Lambda Target Group for VPC Lattice Service
###################################################

# INFO: Not supported attributes
# - `config.health_check`
# - `config.ip_address_type`
# - `config.port`
# - `config.protocol`
# - `config.protocol_version`
# - `config.vpc_identifier`
resource "aws_vpclattice_target_group" "this" {
  name = var.name
  type = "LAMBDA"

  config {
    lambda_event_structure_version = var.lambda_event_structure_version
  }

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
  }

  tags = merge(
    {
      "Name" = local.metadata.name
    },
    local.module_tags,
    var.tags,
  )
}


###################################################
# Targets for Lambda Target Group
###################################################

# INFO: Not supported attributes
# - `target.port`
resource "aws_vpclattice_target_group_attachment" "this" {
  for_each = {
    for target in var.targets :
    target.name => target
  }

  target_group_identifier = aws_vpclattice_target_group.this.id

  target {
    id = each.value.lambda_function
  }
}
