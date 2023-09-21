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

output "rules" {
  description = <<EOF
  The list of rules to enable content-based routing to the target groups that make up the service.
    `id` - Unique identifier for the listener rule.
    `arn` - The ARN for the listener rule.
    `priority` - The priority assigned to the listener rule.
    `name` - The rule name to describe the purpose of the listener rule.
    `conditions` - The rule conditions.
      `method` - The condition of HTTP request method.
      `path` - The condition of HTTP request path.
      `headers` - The condition of HTTP request headers.
    `action` - The action for the listener rule.
      `type` - The action type for the rule of the service.
      `parameters` - The configuration for the parameters of the routing action.
  EOF
  value = {
    for rule in var.rules :
    rule.priority => {
      id       = aws_vpclattice_listener_rule.this[rule.priority].rule_id
      arn      = aws_vpclattice_listener_rule.this[rule.priority].arn
      priority = rule.priority
      name     = aws_vpclattice_listener_rule.this[rule.priority].name

      conditions = {
        method = aws_vpclattice_listener_rule.this[rule.priority].match[0].http_match[0].method
        path = {
          value          = aws_vpclattice_listener_rule.this[rule.priority].match[0].http_match[0].path_match[0].match[0].exact != null ? aws_vpclattice_listener_rule.this[rule.priority].match[0].http_match[0].path_match[0].match[0].exact : aws_vpclattice_listener_rule.this[rule.priority].match[0].http_match[0].path_match[0].match[0].prefix
          operator       = aws_vpclattice_listener_rule.this[rule.priority].match[0].http_match[0].path_match[0].match[0].exact != null ? "EXACT" : "PREFIX"
          case_sensitive = aws_vpclattice_listener_rule.this[rule.priority].match[0].http_match[0].path_match[0].case_sensitive
        }
        headers = [
          for header in aws_vpclattice_listener_rule.this[rule.priority].match[0].http_match[0].header_matches :
          {
            name           = header.name
            value          = header.match[0].exact != null ? header.match[0].exact : (header.match[0].prefix != null ? header.match[0].prefix : header.match[0].contains)
            operator       = header.match[0].exact != null ? "EXACT" : (header.match[0].prefix != null ? "PREFIX" : "CONTAINS")
            case_sensitive = header.case_sensitive
          }
        ]
      }

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
