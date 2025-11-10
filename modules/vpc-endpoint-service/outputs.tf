output "region" {
  description = "The AWS region this module resources resides in."
  value       = aws_vpc_endpoint_service.this.region
}

output "name" {
  description = "The VPC Endpoint Service name."
  value       = var.name
}

output "id" {
  description = "The ID of the VPC endpoint service."
  value       = aws_vpc_endpoint_service.this.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) of the VPC endpoint service."
  value       = aws_vpc_endpoint_service.this.arn
}

output "state" {
  description = "The state of the VPC endpoint service."
  value       = aws_vpc_endpoint_service.this.state
}

output "type" {
  description = "A load balancer type for the VPC Endpoint Service."
  value       = var.type
}

output "load_balancers" {
  description = "A list of ARNs of the load balancers for the VPC Endpoint Service."
  value = (
    var.type == "GWLB"
    ? aws_vpc_endpoint_service.this.gateway_load_balancer_arns
    : var.type == "NLB"
    ? aws_vpc_endpoint_service.this.network_load_balancer_arns
    : []
  )
}

output "service_name" {
  description = "The service name."
  value       = aws_vpc_endpoint_service.this.service_name
}

output "service_type" {
  description = "The service type, `Gateway` or `Interface`."
  value       = aws_vpc_endpoint_service.this.service_type
}

output "availability_zones" {
  description = "The Availability Zones in which the service is available."
  value       = aws_vpc_endpoint_service.this.availability_zones
}

output "supported_ip_address_types" {
  description = "The supported IP address types."
  value       = var.supported_ip_address_types
}

output "supported_regions" {
  description = "The supported AWS regions for the VPC endpoint service."
  value       = aws_vpc_endpoint_service.this.supported_regions
}

output "allowed_principals" {
  description = "A list of the ARNs of allowed principals to discover a VPC endpoint service."
  value       = keys(aws_vpc_endpoint_service_allowed_principal.this)
}

output "manages_vpc_endpoints" {
  description = "Whether or not the service manages its VPC endpoints"
  value       = aws_vpc_endpoint_service.this.manages_vpc_endpoints
}

output "domain_names" {
  description = "The DNS names for the service."
  value       = aws_vpc_endpoint_service.this.base_endpoint_dns_names
}

output "private_domain" {
  description = "The private DNS name for the service."
  value       = aws_vpc_endpoint_service.this.private_dns_name
}

output "private_domain_configurations" {
  description = "List of objects containing information about the endpoint service private DNS name configuration."
  value       = aws_vpc_endpoint_service.this.private_dns_name_configuration
}

output "connection_notifications" {
  description = <<EOF
  A list of Endpoint Connection Notifications for VPC Endpoint Service events.
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
