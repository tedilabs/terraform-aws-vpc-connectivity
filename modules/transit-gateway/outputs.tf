output "id" {
  description = "The ID of the Transit Gateway."
  value       = aws_ec2_transit_gateway.this.id
}

output "arn" {
  description = "The ARN (Amazon Resource Name) of the Transit Gateway."
  value       = aws_ec2_transit_gateway.this.arn
}

output "name" {
  description = "The name of the Transit Gateway."
  value       = local.metadata.name
}

output "description" {
  description = "The description of the Transit Gateway."
  value       = aws_ec2_transit_gateway.this.description
}

output "owner_id" {
  description = "ID of the AWS account that owns the Transit Gateway."
  value       = aws_ec2_transit_gateway.this.id
}

output "asn" {
  description = "The ASN of the Amazon side of the Transit Gateway."
  value       = aws_ec2_transit_gateway.this.amazon_side_asn
}

output "cidr_blocks" {
  description = "The set of IPv4 or IPv6 CIDR blocks for the Transit Gateway."
  value       = aws_ec2_transit_gateway.this.transit_gateway_cidr_blocks
}

output "default_association_route_table" {
  description = <<EOF
  The configuration for the default association route table for automatic association.
    `enabled` - Whether to automatically associate transit gateway attachments with this transit gateway's default route table.
    `route_table` - The ID of the default association route table.
  EOF
  value = {
    enabled     = aws_ec2_transit_gateway.this.default_route_table_association == "enable"
    route_table = aws_ec2_transit_gateway.this.association_default_route_table_id
  }
}

output "default_propagation_route_table" {
  description = <<EOF
  The configuration for the default propagation route table for automatic propagation.
    `enabled` - Whether to automatically propagate transit gateway attachments with this transit gateway's default route table.
    `route_table` - The ID of the default propagation route table.
  EOF
  value = {
    enabled     = aws_ec2_transit_gateway.this.default_route_table_propagation == "enable"
    route_table = aws_ec2_transit_gateway.this.propagation_default_route_table_id
  }
}

output "attributes" {
  description = "Attributes that applied to the Transit Gateway."
  value = {
    dns_support_enabled                   = aws_ec2_transit_gateway.this.dns_support == "enable"
    vpn_ecmp_support_enabled              = aws_ec2_transit_gateway.this.vpn_ecmp_support == "enable"
    multicast_support_enabled             = aws_ec2_transit_gateway.this.multicast_support == "enable"
    auto_accept_cross_account_attachments = aws_ec2_transit_gateway.this.auto_accept_shared_attachments == "enable"
  }
}

output "sharing" {
  description = <<EOF
  The configuration for sharing of the Transit Gateway.
    `status` - An indication of whether the Transit Gateway is shared with other AWS accounts, or was shared with the current account by another AWS account. Sharing is configured through AWS Resource Access Manager (AWS RAM). Values are `NOT_SHARED`, `SHARED_BY_ME` or `SHARED_WITH_ME`.
    `shares` - The list of resource shares via RAM (Resource Access Manager).
  EOF
  value = {
    status = length(module.share) > 0 ? "SHARED_BY_ME" : "NOT_SHARED"
    shares = module.share
  }
}
