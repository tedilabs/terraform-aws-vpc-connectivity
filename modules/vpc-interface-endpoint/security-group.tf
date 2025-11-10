###################################################
# Security Group for Interface Endpoint
###################################################

module "security_group" {
  source  = "tedilabs/network/aws//modules/security-group"
  version = "~> 1.0.0"

  count = var.default_security_group.enabled ? 1 : 0

  region = var.region

  name        = coalesce(var.default_security_group.name, local.metadata.name)
  description = var.default_security_group.description
  vpc_id      = var.vpc_id

  ingress_rules = var.default_security_group.ingress_rules

  revoke_rules_on_delete = true
  resource_group = {
    enabled = false
  }
  module_tags_enabled = false

  tags = merge(
    local.module_tags,
    var.tags,
  )
}
