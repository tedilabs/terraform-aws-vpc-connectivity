output "vpc_one" {
  description = "The VPC one."
  value       = module.vpc_one
}

output "vpc_two" {
  description = "The VPC two."
  value       = module.vpc_two
}

output "peering" {
  description = "The VPC Peering Connection."
  value       = module.peering
}
