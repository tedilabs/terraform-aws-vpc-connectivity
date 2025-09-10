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
  value       = aws_vpc_peering_connection_accepter.this.accept_status
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

output "requester_options" {
  description = "The requester options of the VPC Peering Connection."
  value       = var.requester_options
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

output "accepter_options" {
  description = "The accepter options of the VPC Peering Connection."
  value       = var.accepter_options
}
