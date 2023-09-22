output "target_group" {
  description = "The Instance target group of VPC Lattice."
  value       = module.target_group
}

output "instances" {
  description = "The EC2 instances."
  value       = module.instance
}
