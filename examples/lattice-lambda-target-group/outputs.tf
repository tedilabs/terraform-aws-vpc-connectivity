output "target_group" {
  description = "The ALB target group of VPC Lattice."
  value       = module.target_group
}

output "lambda_function" {
  description = "The Lambda function for VPC Lattice."
  value       = module.lambda_function
}
