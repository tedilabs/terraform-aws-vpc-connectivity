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

data "aws_availability_zones" "available" {
  region = var.region

  state = "available"
}

data "aws_subnet" "this" {
  for_each = var.network_mapping

  region = var.region

  id = each.value.subnet

  lifecycle {
    precondition {
      condition     = contains(local.available_az_ids, each.key)
      error_message = "Availability zone ${each.key} is not available."
    }
    postcondition {
      condition     = each.key == self.availability_zone_id
      error_message = "Subnet ${each.value.subnet} is not in the expected availability zone ${each.key}."
    }
  }
}

locals {
  available_az_ids = data.aws_availability_zones.available.zone_ids
  subnet_configurations = {
    for az in aws_vpc_endpoint.this.subnet_configuration :
    az.subnet_id => az
  }
  network_mapping = {
    for zone_id in local.available_az_ids :
    zone_id => try({
      subnet       = var.network_mapping[zone_id].subnet
      ipv4_address = local.subnet_configurations[var.network_mapping[zone_id].subnet].ipv4
      ipv6_address = local.subnet_configurations[var.network_mapping[zone_id].subnet].ipv6
    }, null)
  }

  security_groups = concat(
    (var.default_security_group.enabled
      ? module.security_group[*].id
      : []
    ),
    var.security_groups
  )

  ip_address_types = {
    "IPv4"            = "ipv4"
    "IPv6"            = "ipv6"
    "DUALSTACK"       = "dualstack"
    "SERVICE_DEFINED" = "service-defined"
  }
}


###################################################
# Interface Endpoint
###################################################

# INFO: Not supported attributes
# - `resource_configuration_arn`
# - `route_table_ids`
# - `service_network_arn`
# INFO: Use a separate resource
# - `policy`
# - `private_dns_enabled`
# - `security_group_ids`
# - `subnet_ids`
resource "aws_vpc_endpoint" "this" {
  region = var.region

  vpc_endpoint_type = "Interface"
  service_region    = var.service_region
  service_name      = var.service_name
  auto_accept       = var.auto_accept

  vpc_id          = var.vpc_id
  ip_address_type = local.ip_address_types[var.ip_address_type]
  subnet_ids = [
    for az in var.network_mapping :
    az.subnet
  ]

  dynamic "subnet_configuration" {
    for_each = [
      for az in var.network_mapping :
      az
      if az.ipv4_address != null || az.ipv6_address != null
    ]
    iterator = az

    content {
      subnet_id = az.value.subnet

      ipv4 = az.value.ipv4_address
      ipv6 = az.value.ipv6_address
    }
  }

  dynamic "dns_options" {
    for_each = var.private_dns.enabled ? ["go"] : []

    content {
      dns_record_ip_type                             = local.ip_address_types[var.private_dns.record_ip_type]
      private_dns_only_for_inbound_resolver_endpoint = var.private_dns.only_for_inbound_resolver_endpoint
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
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
# Private DNS for Interface Endpoint
###################################################

resource "aws_vpc_endpoint_private_dns" "this" {
  region = aws_vpc_endpoint.this.region

  vpc_endpoint_id = (length(aws_vpc_endpoint_security_group_association.this) > 0
    ? aws_vpc_endpoint_security_group_association.this[0].vpc_endpoint_id
    : aws_vpc_endpoint.this.id
  )
  private_dns_enabled = var.private_dns.enabled
}


###################################################
# Policy for Interface Endpoint
###################################################

resource "aws_vpc_endpoint_policy" "this" {
  region = var.region

  vpc_endpoint_id = aws_vpc_endpoint.this.id
  policy          = var.policy
}


###################################################
# Subnet Associations for Interface Endpoint
###################################################

# INFO: Not support IP address allocation per subnet
# resource "aws_vpc_endpoint_subnet_association" "this" {
#   for_each = var.network_mapping
#
#   region = var.region
#
#   vpc_endpoint_id = aws_vpc_endpoint.this.id
#   subnet_id       = each.value.subnet
#
#   lifecycle {
#     precondition {
#       condition     = contains(local.available_az_ids, each.key)
#       error_message = "Availability zone ${each.key} is not available."
#     }
#   }
# }


###################################################
# Security Groups for Interface Endpoint
###################################################

resource "aws_vpc_endpoint_security_group_association" "this" {
  count = length(local.security_groups)

  region = var.region

  vpc_endpoint_id   = aws_vpc_endpoint_policy.this.vpc_endpoint_id
  security_group_id = local.security_groups[count.index]

  replace_default_association = count.index == 0
}


###################################################
# Connection Notifications
###################################################

# INFO: Not supported attributes
# - `vpc_endpoint_service_id`
resource "aws_vpc_endpoint_connection_notification" "this" {
  for_each = {
    for config in var.connection_notifications :
    config.name => config
  }

  region = var.region

  vpc_endpoint_id = aws_vpc_endpoint.this.id

  connection_notification_arn = each.value.sns_topic
  connection_events           = each.value.events
}
