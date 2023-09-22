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

locals {
  default_ports = {
    "HTTP"  = 80
    "HTTPS" = 443
  }
}


###################################################
# Instance Target Group for VPC Lattice Service
###################################################

# INFO: Not supported attributes
# - `config.ip_address_type`
resource "aws_vpclattice_target_group" "this" {
  name = var.name
  type = "INSTANCE"

  config {
    vpc_identifier = var.vpc

    port             = coalesce(var.port, local.default_ports[var.protocol])
    protocol         = var.protocol
    protocol_version = var.protocol_version

    health_check {
      enabled = var.health_check.enabled

      port             = var.health_check.port
      protocol         = var.health_check.protocol
      protocol_version = var.health_check.protocol_version
      path             = var.health_check.path

      matcher {
        value = var.health_check.success_codes
      }

      health_check_interval_seconds = var.health_check.interval
      health_check_timeout_seconds  = var.health_check.timeout

      healthy_threshold_count   = var.health_check.healthy_threshold
      unhealthy_threshold_count = var.health_check.unhealthy_threshold
    }
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
# Targets for Instance Target Group
###################################################

resource "aws_vpclattice_target_group_attachment" "this" {
  for_each = {
    for target in var.targets :
    target.name => target
  }

  target_group_identifier = aws_vpclattice_target_group.this.id

  target {
    id   = each.value.instance
    port = coalesce(each.value.port, var.port)
  }
}
