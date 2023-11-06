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

data "aws_vpc_endpoint_service" "this" {
  service      = lower(var.service)
  service_type = "Gateway"
}


###################################################
# Gateway Endpoint
###################################################

# INFO: Not supported attributes
# - `auto_accept`
# - `dns_options`
# - `ip_address_type`
# - `private_dns_enabled`
# - `security_group_ids`
# - `subnet_ids`
# INFO: Use a separate resource
# - `policy`
# - `route_table_ids`
resource "aws_vpc_endpoint" "this" {
  vpc_endpoint_type = "Gateway"
  service_name      = data.aws_vpc_endpoint_service.this.service_name
  vpc_id            = var.vpc_id

  auto_accept = true

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
# Policy for Gateway Endpoint
###################################################

resource "aws_vpc_endpoint_policy" "this" {
  vpc_endpoint_id = aws_vpc_endpoint.this.id
  policy          = var.policy
}


###################################################
# Route Table Associations for Gateway Endpoint
###################################################

resource "aws_vpc_endpoint_route_table_association" "this" {
  count = length(var.route_tables)

  vpc_endpoint_id = aws_vpc_endpoint.this.id
  route_table_id  = var.route_tables[count.index]
}
