###################################################
# Listeners for VPC Lattice Service
###################################################

module "listener" {
  source = "../lattice-service-listener"

  for_each = {
    for listener in var.listeners :
    listener.name => listener
  }

  service = aws_vpclattice_service.this.arn

  name     = each.key
  port     = try(each.value.port, null)
  protocol = each.value.protocol

  default_action_type       = each.value.default_action_type
  default_action_parameters = try(each.value.default_action_parameters, {})

  rules = try(each.value.rules, [])

  resource_group_enabled = false
  module_tags_enabled    = false

  tags = merge(
    local.module_tags,
    var.tags,
    each.value.tags,
  )
}
