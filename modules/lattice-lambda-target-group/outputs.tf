output "id" {
  description = "The ID of the target group."
  value       = aws_vpclattice_target_group.this.id
}

output "arn" {
  description = "The ARN of the target group."
  value       = aws_vpclattice_target_group.this.arn
}

output "name" {
  description = "The name of the target group."
  value       = aws_vpclattice_target_group.this.name
}

output "type" {
  description = "The type of target group. Always `LAMBDA`."
  value       = aws_vpclattice_target_group.this.type
}

output "status" {
  description = "The status of the target group."
  value       = aws_vpclattice_target_group.this.status
}

output "lambda_event_structure_version" {
  description = "The version of the event structure that the Lambda function receives."
  value       = one(aws_vpclattice_target_group.this.config[*].lambda_event_structure_version)
}

output "targets" {
  description = <<EOF
  The list of targets of the target group.
    `name` - The name of the target. This value is only used internally within Terraform code.
    `lambda_function` - The Amazon Resource Name (ARN) of the target Lambda function.
  EOF
  value = {
    for name, target in aws_vpclattice_target_group_attachment.this :
    name => {
      name            = name
      lambda_function = one(target.target[*].id)
    }
  }
}
