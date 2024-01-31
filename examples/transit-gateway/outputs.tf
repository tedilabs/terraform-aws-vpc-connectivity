output "transit_gateway" {
  description = "The Transit Gateway."
  value       = module.transit_gateway
}

output "route_table" {
  description = "The Transit Gateway route table."
  value       = module.route_table
}
