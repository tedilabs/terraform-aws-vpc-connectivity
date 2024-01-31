output "id" {
  description = "The ID of the Transit Gateway route table."
  value       = aws_ec2_transit_gateway_route_table.this.id
}

output "arn" {
  description = "The ARN (Amazon Resource Name) of the Transit Gateway route table."
  value       = aws_ec2_transit_gateway_route_table.this.arn
}

output "name" {
  description = "The name of the Transit Gateway route table."
  value       = local.metadata.name
}

output "transit_gateway" {
  description = "The associated Transit Gateway."
  value = {
    id = aws_ec2_transit_gateway_route_table.this.transit_gateway_id
  }
}

output "is_default_association_route_table" {
  description = "Whether this is the default association route table for the Transit Gateway."
  value       = aws_ec2_transit_gateway_route_table.this.default_association_route_table
}

output "is_default_propagation_route_table" {
  description = "Whether this is the default propagation route table for the Transit Gateway."
  value       = aws_ec2_transit_gateway_route_table.this.default_propagation_route_table
}

output "attachment_associations" {
  description = "The attachment association configurations for the Transit Gateway route table."
  value = {
    for id, association in aws_ec2_transit_gateway_route_table_association.this :
    id => {
      id            = association.transit_gateway_attachment_id
      resource_type = association.resource_type
      resource_id   = association.resource_id
    }
  }
}

output "attachment_route_propagations" {
  description = "The route propagation configurations for the Transit Gateway route table."
  value = {
    for id, propagation in aws_ec2_transit_gateway_route_table_propagation.this :
    id => {
      id            = propagation.transit_gateway_attachment_id
      resource_type = propagation.resource_type
      resource_id   = propagation.resource_id
    }
  }
}

output "prefix_list_routes" {
  description = "The route rules for destinations to Prefix Lists."
  value = [
    for route in aws_ec2_transit_gateway_prefix_list_reference.this : {
      destination  = route.prefix_list_id
      target       = route.blackhole ? null : route.transit_gateway_attachment_id
      is_blackhole = route.blackhole
    }
  ]
}

output "static_routes" {
  description = "The static route rules for destinations to IPv4 / IPv6 CIDRs."
  value = [
    for route in aws_ec2_transit_gateway_route.this : {
      destination  = route.destination_cidr_block
      target       = route.blackhole ? null : route.transit_gateway_attachment_id
      is_blackhole = route.blackhole
    }
  ]
}
