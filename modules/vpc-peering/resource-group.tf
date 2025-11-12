locals {
  resource_group_name = (var.resource_group.name != ""
    ? var.resource_group.name
    : join(".", [
      local.metadata.package,
      local.metadata.module,
      replace(local.metadata.name, "/[^a-zA-Z0-9_\\.-]/", "-"),
    ])
  )
}


module "resource_group_requester" {
  source  = "tedilabs/misc/aws//modules/resource-group"
  version = "~> 0.12.0"

  providers = {
    aws = aws.requester
  }

  count = (var.resource_group.enabled && var.module_tags_enabled) ? 1 : 0

  region = local.requester.region

  name        = local.resource_group_name
  description = var.resource_group.description

  query = {
    resource_tags = local.module_tags
  }

  module_tags_enabled = false
  tags = merge(
    local.module_tags,
    var.tags,
  )
}

module "resource_group_accepter" {
  source  = "tedilabs/misc/aws//modules/resource-group"
  version = "~> 0.12.0"

  providers = {
    aws = aws.accepter
  }

  count = (alltrue([
    var.resource_group.enabled,
    var.module_tags_enabled,
    anytrue([
      local.requester.region != local.accepter.region,
      local.requester.account != local.accepter.account,
    ])
  ]) ? 1 : 0)

  region = local.accepter.region

  name        = local.resource_group_name
  description = var.resource_group.description

  query = {
    resource_tags = local.module_tags
  }

  module_tags_enabled = false
  tags = merge(
    local.module_tags,
    var.tags,
  )
}
