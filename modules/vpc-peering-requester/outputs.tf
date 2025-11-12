output "region" {
  description = "The AWS region this module resources resides in."
  value       = aws_vpc_peering_connection.this.region
}

output "name" {
  description = "The VPC Peering name."
  value       = var.name
}

output "id" {
  description = "The ID of the VPC Peering Connection."
  value       = aws_vpc_peering_connection.this.id
}

output "status" {
  description = "The status of the VPC Peering Connection request."
  value       = aws_vpc_peering_connection.this.accept_status
}

output "requester" {
  description = "The requester information including AWS Account ID, Region, VPC ID."
  value = merge(local.requester, {
    ipv4_cidrs = toset([
      for cidr in data.aws_vpc_peering_connection.this.cidr_block_set :
      cidr.cidr_block
    ])
  })
}

output "accepter" {
  description = "The accepter information including AWS Account ID, Region, VPC ID."
  value = merge(local.accepter, {
    ipv4_cidrs = toset([
      for cidr in data.aws_vpc_peering_connection.this.peer_cidr_block_set :
      cidr.cidr_block
    ])
  })
}

output "allow_remote_vpc_dns_resolution" {
  description = "Whether to allow a requester VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the accepter VPC."
  value       = var.allow_remote_vpc_dns_resolution
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
