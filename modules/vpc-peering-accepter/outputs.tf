output "name" {
  description = "The VPC Peering name."
  value       = var.name
}

output "id" {
  description = "The ID of the VPC Peering Connection."
  value       = aws_vpc_peering_connection_accepter.this.id
}

output "status" {
  description = "The status of the VPC Peering Connection request."
  value       = aws_vpc_peering_connection_accepter.this.accept_status
}

output "requester_vpc" {
  description = "The requester information including AWS Account ID, Region, VPC ID."
  value       = local.requester_vpc
}

output "accepter_vpc" {
  description = "The accepter information including AWS Account ID, Region, VPC ID."
  value       = local.accepter_vpc
}

output "allow_remote_vpc_dns_resolution" {
  description = "Whether to allow a accepter VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the requester VPC."
  value       = var.allow_remote_vpc_dns_resolution
}
