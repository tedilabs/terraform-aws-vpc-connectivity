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

output "requester_vpc" {
  description = "The requester information including AWS Account ID, Region, VPC ID."
  value = merge(local.requester_vpc, {
    ipv4_cidrs = toset([
      for cidr in data.aws_vpc_peering_connection.this.cidr_block_set :
      cidr.cidr_block
    ])
  })
}

output "accepter_vpc" {
  description = "The accepter information including AWS Account ID, Region, VPC ID."
  value = merge(local.accepter_vpc, {
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
