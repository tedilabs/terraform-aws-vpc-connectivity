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
  ip_address_types = {
    "IPv4" = "ipv4"
    "IPv6" = "ipv6"
  }
}


###################################################
# Endpoint Service
###################################################

# INFO: Use a separate resource
# - `allowed_principals`
resource "aws_vpc_endpoint_service" "this" {
  region = var.region

  gateway_load_balancer_arns = (var.type == "GWLB"
    ? var.load_balancers
    : null
  )
  network_load_balancer_arns = (var.type == "NLB"
    ? var.load_balancers
    : null
  )

  private_dns_name    = var.private_domain
  acceptance_required = var.acceptance_required
  supported_ip_address_types = [
    for ip_address_type in var.supported_ip_address_types :
    local.ip_address_types[ip_address_type]
  ]
  supported_regions = var.supported_regions

  tags = merge(
    {
      "Name" = local.metadata.name
    },
    local.module_tags,
    var.tags,
  )
}


###################################################
# Allowed Principals
###################################################

resource "aws_vpc_endpoint_service_allowed_principal" "this" {
  for_each = toset(var.allowed_principals)

  region = var.region

  vpc_endpoint_service_id = aws_vpc_endpoint_service.this.id
  principal_arn           = each.value
}


###################################################
# Connection Notifications
###################################################

# INFO: Not supported attributes
# - `vpc_endpoint_id`
resource "aws_vpc_endpoint_connection_notification" "this" {
  for_each = {
    for config in var.connection_notifications :
    config.name => config
  }

  region = var.region

  vpc_endpoint_service_id = aws_vpc_endpoint_service.this.id

  connection_notification_arn = each.value.sns_topic
  connection_events           = each.value.events
}
