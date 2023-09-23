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
  description = "The type of target group. Always `INSTANCE`."
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

output "health_check" {
  description = <<EOF
  The health check configuration of the target group.
    `enabled` - Whether to enable health check.
    `protocol` - The protocol used when performing health checks on targets.
    `protocol_version` - The protocol version used when performing health checks on targets.
    `port` - The port used when performing health checks on targets.
    `path` - The destination for health checks on the targets.
    `success_codes` - The HTTP codes to use when checking for a successful response from a target.
    `interval` - The approximate amount of time between health checks of an individual target.
    `timeout` - The amount of time, in seconds, during which no response means a failed health check.
    `healthy_threshold` - The number of consecutive successful health checks required before an unhealthy target is considered healthy.
    `unhealthy_threshold` - The number of consecutive health check failures required before considering a target unhealthy.
  EOF
  value = {
    enabled = one(aws_vpclattice_target_group.this.config[*].health_check[0].enabled)

    port             = one(aws_vpclattice_target_group.this.config[*].health_check[0].port)
    protocol         = one(aws_vpclattice_target_group.this.config[*].health_check[0].protocol)
    protocol_version = one(aws_vpclattice_target_group.this.config[*].health_check[0].protocol_version)
    path             = one(aws_vpclattice_target_group.this.config[*].health_check[0].path)

    success_codes = one(aws_vpclattice_target_group.this.config[*].health_check[0].matcher[0].value)

    interval = one(aws_vpclattice_target_group.this.config[*].health_check[0].health_check_interval_seconds)
    timeout  = one(aws_vpclattice_target_group.this.config[*].health_check[0].health_check_timeout_seconds)

    healthy_threshold   = one(aws_vpclattice_target_group.this.config[*].health_check[0].healthy_threshold_count)
    unhealthy_threshold = one(aws_vpclattice_target_group.this.config[*].health_check[0].unhealthy_threshold_count)
  }
}

output "targets" {
  description = <<EOF
  The list of targets of the target group.
    `name` - The name of the target. This value is only used internally within Terraform code.
    `instance` - This is the Instance ID for an instance.
    `port` - The port on which the target is listening.
  EOF
  value = {
    for name, target in aws_vpclattice_target_group_attachment.this :
    name => {
      name     = name
      instance = one(target.target[*].id)
      port     = one(target.target[*].port)
    }
  }
}
