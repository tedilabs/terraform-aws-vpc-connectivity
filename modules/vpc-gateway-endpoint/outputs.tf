output "region" {
  description = "The AWS region this module resources resides in."
  value       = aws_vpc_endpoint.this.region
}

output "name" {
  description = "The VPC Gateway Endpoint name."
  value       = var.name
}

output "service_name" {
  description = "The service name of the VPC Gateway Endpoint."
  value       = aws_vpc_endpoint.this.service_name
}

output "id" {
  description = "The ID of the VPC endpoint."
  value       = aws_vpc_endpoint.this.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) of the VPC endpoint."
  value       = aws_vpc_endpoint.this.arn
}

output "owner_id" {
  description = "The owner ID of the VPC endpoint."
  value       = aws_vpc_endpoint.this.owner_id
}

output "type" {
  description = "The type of the VPC endpoint."
  value       = "GATEWAY"
}

output "state" {
  description = "The state of the VPC endpoint."
  value       = upper(aws_vpc_endpoint.this.state)
}

output "vpc_id" {
  description = "The VPC ID of the VPC endpoint."
  value       = aws_vpc_endpoint.this.vpc_id
}

output "prefix_list" {
  description = <<EOF
  The information of the prefix list of the VPC endpoint.
    `id` - The prefix list ID of the exposed AWS service.
    `ipv4_cidrs` - The list of CIDR blocks for the exposed AWS service.
  EOF
  value = {
    id         = aws_vpc_endpoint.this.prefix_list_id
    ipv4_cidrs = aws_vpc_endpoint.this.cidr_blocks
  }
}

output "route_tables" {
  description = <<EOF
  The list of route table IDs which is associated with the VPC endpoint.
  EOF
  value       = aws_vpc_endpoint_route_table_association.this[*].route_table_id
}

output "resource_group" {
  description = "The resource group created to manage resources in this module."
  value = merge(
    {
      enabled = var.resource_group.enabled && var.module_tags_enabled
    },
    (var.resource_group.enabled && var.module_tags_enabled
      ? {
        arn  = module.resource_group[0].arn
        name = module.resource_group[0].name
      }
      : {}
    )
  )
}
