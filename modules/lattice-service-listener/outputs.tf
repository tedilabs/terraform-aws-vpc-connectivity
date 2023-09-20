output "service" {
  description = "The associated VPC Lattice service."
  value = {
    id  = aws_vpclattice_listener.this.service_identifier
    arn = aws_vpclattice_listener.this.service_arn
  }
}

output "id" {
  description = "The ID of the service listener."
  value       = aws_vpclattice_listener.this.listener_id
}

output "arn" {
  description = "The ARN of the service listener."
  value       = aws_vpclattice_listener.this.arn
}

output "name" {
  description = "The name of the service listener."
  value       = aws_vpclattice_listener.this.name
}

output "port" {
  description = "The number of port on which the listener of the service is listening."
  value       = aws_vpclattice_listener.this.port
}

output "protocol" {
  description = "The protocol for the service listener."
  value       = aws_vpclattice_listener.this.protocol
}

output "default_action" {
  description = <<EOF
  The configuration for default routing action of the service listener.
    `type` - The type of default routing action.
    `parameters` - The configuration for the parameters of the default routing action. `default_action_parameters` block as defined below.
  EOF
  value = {
    type = var.default_action_type
    parameters = {
      "FIXED_RESPONSE" = one(aws_vpclattice_listener.this.default_action[0].fixed_response[*])
      "FORWARD" = {
        destinations = one(aws_vpclattice_listener.this.default_action[0].forward[*].target_groups)
      }
    }[var.default_action_type]
  }
}

# TODO: Update Docs
# TODO: Support Match
output "rules" {
  description = <<EOF
  The configuration for default routing action of the service listener.
    `type` - The type of default routing action.
    `parameters` - The configuration for the parameters of the default routing action. `default_action_parameters` block as defined below.
  EOF
  value = {
    for rule in var.rules :
    rule.priority => {
      id       = aws_vpclattice_listener_rule.this[rule.priority].rule_id
      arn      = aws_vpclattice_listener_rule.this[rule.priority].arn
      priority = rule.priority
      name     = aws_vpclattice_listener_rule.this[rule.priority].name

      action = {
        type       = rule.action_type
        parameters = rule.action_parameters
        parameters = {
          "FIXED_RESPONSE" = one(aws_vpclattice_listener_rule.this[rule.priority].action[0].fixed_response[*])
          "FORWARD" = {
            destinations = one(aws_vpclattice_listener_rule.this[rule.priority].action[0].forward[*].target_groups)
          }
        }[rule.action_type]
      }
      z = {
        for k, v in aws_vpclattice_listener_rule.this[rule.priority] :
        k => v
        if !contains(["name", "priority", "rule_id", "id", "arn", "listener_identifier", "service_identifier", "tags", "tags_all", "timeouts", "action"], k)
      }
    }
  }
}

output "created_at" {
  description = "Date and time that the listener was created, specified in ISO-8601 format."
  value       = aws_vpclattice_listener.this.created_at
}

output "updated_at" {
  description = "Date and time that the listener was last updated, specified in ISO-8601 format."
  value       = aws_vpclattice_listener.this.last_updated_at
}
