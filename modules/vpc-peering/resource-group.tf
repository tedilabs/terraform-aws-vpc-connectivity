locals {
  resource_group_name = (var.resource_group_name != ""
    ? var.resource_group_name
    : join(".", [
      local.metadata.package,
      local.metadata.module,
      replace(local.metadata.name, "/[^a-zA-Z0-9_\\.-]/", "-"),
    ])
  )
}


module "resource_group_requester" {
  source  = "tedilabs/misc/aws//modules/resource-group"
  version = "~> 0.10.0"

  providers = {
    aws = aws.requester
  }

  count = (var.resource_group_enabled && var.module_tags_enabled) ? 1 : 0

  name        = local.resource_group_name
  description = var.resource_group_description

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
  version = "~> 0.10.0"

  providers = {
    aws = aws.accepter
  }

  count = (alltrue([
    var.resource_group_enabled,
    var.module_tags_enabled,
    anytrue([
      local.requester_vpc.region != local.accepter_vpc.region,
      local.requester_vpc.account != local.accepter_vpc.account,
    ])
  ]) ? 1 : 0)

  name        = local.resource_group_name
  description = var.resource_group_description

  query = {
    resource_tags = local.module_tags
  }

  module_tags_enabled = false
  tags = merge(
    local.module_tags,
    var.tags,
  )
}
