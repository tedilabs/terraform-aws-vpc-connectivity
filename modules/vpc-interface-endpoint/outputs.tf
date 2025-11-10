output "region" {
  description = "The AWS region this module resources resides in."
  value       = aws_vpc_endpoint.this.region
}

output "name" {
  description = "The VPC Interface Endpoint name."
  value       = var.name
}

output "service_region" {
  description = "The service region of the VPC Interface Endpoint."
  value       = aws_vpc_endpoint.this.service_region
}

output "service_name" {
  description = "The service name of the VPC Interface Endpoint."
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
  description = "The Owner ID of the VPC endpoint."
  value       = aws_vpc_endpoint.this.owner_id
}

output "type" {
  description = "The type of the VPC endpoint."
  value       = "INTERFACE"
}

output "state" {
  description = "The state of the VPC endpoint."
  value       = upper(aws_vpc_endpoint.this.state)
}

output "requester_managed" {
  description = "Whether or not the VPC Endpoint is being managed by its service."
  value       = aws_vpc_endpoint.this.requester_managed
}

output "vpc_id" {
  description = "The VPC ID of the VPC endpoint."
  value       = aws_vpc_endpoint.this.vpc_id
}

output "network_mapping" {
  description = "The configuration for the endpoint how routes traffic to targets in which subnets and IP address settings."
  value       = local.network_mapping
}

output "ip_address_type" {
  description = "The type of IP addresses used by the VPC endpoint."
  value       = var.ip_address_type
}

output "default_security_group" {
  description = "The default security group ID of the VPC endpoint."
  value       = one(module.security_group[*].id)
}

output "security_groups" {
  description = "A set of security group IDs which is assigned to the VPC endpoint."
  value       = aws_vpc_endpoint.this.security_group_ids
}

output "network_interfaces" {
  description = "One or more network interfaces for the VPC Endpoint."
  value       = aws_vpc_endpoint.this.network_interface_ids
}

output "private_dns" {
  description = "The configuration of the private DNS settings for the VPC Endpoint."
  value = {
    enabled                            = aws_vpc_endpoint.this.private_dns_enabled
    record_ip_type                     = var.private_dns.record_ip_type
    only_for_inbound_resolver_endpoint = aws_vpc_endpoint.this.dns_options[0].private_dns_only_for_inbound_resolver_endpoint
  }
}

output "dns_entries" {
  description = "The DNS entries for the VPC Endpoint."
  value       = aws_vpc_endpoint.this.dns_entry
}

output "connection_notifications" {
  description = <<EOF
  A list of Endpoint Connection Notifications for VPC Endpoint events.
  EOF
  value = {
    for name, notification in aws_vpc_endpoint_connection_notification.this :
    name => {
      id        = notification.id
      state     = notification.state
      events    = notification.connection_events
      sns_topic = notification.connection_notification_arn
    }
  }
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

# output "debug" {
#   value = {
#     for k, v in aws_vpc_endpoint.this :
#     k => v
#     if !contains(["tags_all", "timeouts", "id", "arn", "security_group_ids", "region", "service_region", "service_name", "private_dns_enabled", "subnet_ids", "vpc_id", "vpc_endpoint_type", "tags", "state", "service_network_arn", "route_table_ids", "resource_configuration_arn", "network_interface_ids", "ip_address_type", "dns_entry", "auto_accept", "owner_id", "cidr_blocks", "prefix_list_id", "policy", "dns_options", "subnet_configuration"], k)
#   }
# }
