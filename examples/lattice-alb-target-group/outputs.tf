output "target_group" {
  description = "The ALB target group of VPC Lattice."
  value       = module.target_group
}

output "alb" {
  description = "The ALB (Application Load Balancer) for VPC Lattice."
  value       = module.alb
}
