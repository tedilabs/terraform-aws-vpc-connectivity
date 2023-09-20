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
  is_arn = startswith(var.service, "arn:aws:vpc-lattice:")
  default_ports = {
    "HTTP"  = 80
    "HTTPS" = 443
  }
}


###################################################
# Service Listener for VPC Lattice
###################################################

resource "aws_vpclattice_listener" "this" {
  service_arn        = local.is_arn ? var.service : null
  service_identifier = local.is_arn ? null : var.service

  name = var.name

  port     = coalesce(var.port, local.default_ports[var.protocol])
  protocol = var.protocol

  default_action {
    dynamic "fixed_response" {
      for_each = (var.default_action_type == "FIXED_RESPONSE"
        ? [var.default_action_parameters]
        : []
      )

      content {
        status_code = fixed_response.value.status_code
      }
    }

    dynamic "forward" {
      for_each = (var.default_action_type == "FORWARD"
        ? [var.default_action_parameters]
        : []
      )

      content {
        dynamic "target_groups" {
          for_each = forward.value.destinations

          content {
            target_group_identifier = target_groups.value.target_group
            weight                  = target_groups.value.weight
          }
        }
      }
    }
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
# Service Listener Rules for VPC Lattice
###################################################

resource "aws_vpclattice_listener_rule" "this" {
  for_each = {
    for rule in var.rules :
    rule.priority => rule
  }

  priority            = each.key
  name                = coalesce(each.value.name, "${var.name}-${each.key}")
  listener_identifier = aws_vpclattice_listener.this.listener_id
  service_identifier  = aws_vpclattice_listener.this.service_identifier

  match {
    http_match {

      header_matches {
        name           = "example-header"
        case_sensitive = false

        match {
          exact = "example-contains"
        }
      }

      path_match {
        case_sensitive = true
        match {
          prefix = "/example-path"
        }
      }
    }
  }

  action {
    dynamic "fixed_response" {
      for_each = (each.value.action_type == "FIXED_RESPONSE"
        ? [each.value.action_parameters]
        : []
      )

      content {
        status_code = fixed_response.value.status_code
      }
    }

    dynamic "forward" {
      for_each = (each.value.action_type == "FORWARD"
        ? [each.value.action_parameters]
        : []
      )

      content {
        dynamic "target_groups" {
          for_each = forward.value.destinations

          content {
            target_group_identifier = target_groups.value.target_group
            weight                  = target_groups.value.weight
          }
        }
      }
    }
  }

  tags = merge(
    {
      "Name" = "${var.name}-${each.key}"
    },
    local.module_tags,
    var.tags,
  )
}
