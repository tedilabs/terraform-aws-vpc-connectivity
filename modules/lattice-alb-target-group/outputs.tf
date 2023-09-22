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

output "vpc" {
  description = "The ID of the VPC which the target group belongs to."
  value       = one(aws_vpclattice_target_group.this.config[*].vpc_identifier)
}

output "type" {
  description = "The type of target group. Always `IP`."
  value       = aws_vpclattice_target_group.this.type
}

output "status" {
  description = "The status of the target group."
  value       = aws_vpclattice_target_group.this.status
}

output "port" {
  description = "The port on which the targets are listening."
  value       = one(aws_vpclattice_target_group.this.config[*].port)
}

output "protocol" {
  description = "The protocol to use for routing traffic to the targets."
  value       = one(aws_vpclattice_target_group.this.config[*].protocol)
}

output "protocol_version" {
  description = "The protocol version."
  value       = one(aws_vpclattice_target_group.this.config[*].protocol_version)
}

output "targets" {
  description = <<EOF
  The list of targets of the target group.
    `name` - The name of the target. This value is only used internally within Terraform code.
    `alb` - The Amazon Resource Name (ARN) of the target ALB (Application Load Balancer).
    `port` - The port on which the target is listening.
  EOF
  value = {
    for name, target in aws_vpclattice_target_group_attachment.this :
    name => {
      name = name
      alb  = one(target.target[*].id)
      port = one(target.target[*].port)
    }
  }
}
