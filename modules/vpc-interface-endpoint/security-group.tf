###################################################
# Security Group for Interface Endpoint
###################################################

module "security_group" {
  source  = "tedilabs/network/aws//modules/security-group"
  version = "~> 0.31.0"

  count = var.default_security_group.enabled ? 1 : 0

  name        = coalesce(var.default_security_group.name, local.metadata.name)
  description = var.default_security_group.description
  vpc_id      = var.vpc_id

  ingress_rules = [
    for i, rule in var.default_security_group.ingress_rules :
    merge({
      id        = rule.id
      protocol  = "tcp"
      from_port = 443
      to_port   = 443
    }, rule)
  ]

  revoke_rules_on_delete = true
  resource_group_enabled = false
  module_tags_enabled    = false

  tags = merge(
    local.module_tags,
    var.tags,
  )
}
