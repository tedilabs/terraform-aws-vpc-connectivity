variable "service" {
  description = "(Required) The ID or ARN (Amazon Resource Name) of the VPC Lattice service."
  type        = string
  nullable    = false

  validation {
    condition = anytrue([
      startswith(var.service, "arn:aws:vpc-lattice:"),
      startswith(var.service, "sn-"),
    ])
    error_message = "Valid value for `service` must be the ID or ARN (Amazon Resource Name) of the VPC Lattice service."
  }
}

variable "name" {
  description = "(Required) The name of the service listener. The name must be unique within the service. The valid characters are a-z, 0-9, and hyphens (-). You can't use a hyphen as the first or last character, or immediately after another hyphen."
  type        = string
  nullable    = false
}

variable "port" {
  description = "(Optional) The number of port on which the listener of the service is listening. Valid values are from `1` to `65535`. If `port` is not specified and `protocol` is `HTTP`, the value will default to `80`. If `port` is not specified and `protocol` is `HTTPS`, the value will default to `443`."
  type        = number
  default     = null
  nullable    = true
}

variable "protocol" {
  description = "(Required) The protocol for the service listener. Valid values are `HTTP` and `HTTPS`."
  type        = string
  nullable    = false

  validation {
    condition     = contains(["HTTP", "HTTPS"], var.protocol)
    error_message = "Valid values are `HTTP` and `HTTPS`."
  }
}

variable "default_action_type" {
  description = "(Required) The type of default routing action. Default action apply to traffic that does not meet the conditions of rules on your listener. Rules can be configured after the listener is created. Valid values are `FORWARD`, `FIXED_RESPONSE`."
  type        = string
  nullable    = false

  validation {
    condition     = contains(["FORWARD", "FIXED_RESPONSE"], var.default_action_type)
    error_message = "Valid values are `FORWARD` and `FIXED_RESPONSE`."
  }
}

variable "default_action_parameters" {
  description = <<EOF
  (Optional) The configuration for the parameters of the default routing action. `default_action_parameters` block as defined below.
    (Optional) `status_code` - Custom HTTP status code to drop client requests and return a custom HTTP response. Valid values are `404`. Only supported if `default_action_type` is `FIXED_RESPONSE`.
    (Optional) `destinations` - A list of one or more target groups to route traffic. Only supported if `default_action_type` is `FORWARD`. Each item of `destinations` block as defined below.
      (Required) `target_group` - The ID or ARN of the target group to which to route traffic.
      (Optional) `weight` - The weight to use routing traffic to `target_group`. how requests are distributed to the target group. Only required if you specify multiple target groups for a forward action. For example, if you specify two target groups, one with a weight of 10 and the other with a weight of 20, the target group with a weight of 20 receives twice as many requests as the other target group. Valid value is `0` to `999`. Defaults to `100`.
  EOF
  type = object({
    status_code = optional(number, 404)
    destinations = optional(list(object({
      target_group = string
      weight       = optional(number, 100)
    })), [])
  })
  default  = {}
  nullable = false

  validation {
    condition = alltrue([
      var.default_action_parameters.status_code >= 200,
      var.default_action_parameters.status_code <= 599,
    ])
    error_message = "Value of `status_code` should be 200 - 599."
  }
  validation {
    condition = alltrue([
      for destination in var.default_action_parameters.destinations :
      alltrue([
        try(destination.weight, 1) >= 0,
        try(destination.weight, 1) <= 999,
      ])
    ])
    error_message = "Value of `destinations[].weight` should be between 0 and 999."
  }
}

variable "rules" {
  description = <<EOF
  (Optional) A list of rules to enable content-based routing to the target groups that make up the service. Each rule consists of a priority, one or more actions, and one or more conditions. Each block of `rules` block as defined below.
    (Required) `priority` - The priority assigned to the rule. Each rule for a specific listener must have a unique priority. The lower the priority number the higher the priority.
    (Optional) `name` - A rule name can describe the purpose of the rule or the type of traffic it is intended to handle. Rule names can't be changed after creation. Defaults to `$(service)-$(priority)`.
    (Required) `conditions` - The rule conditions. `conditions` block as defined below.
      (Optional) `method` - The condition of HTTP request method. Valid values are `GET`, `HEAD`, `POST`, `PUT`, `DELETE`, `CONNECT`, `OPTIONS`, `TRACE`, `PATCH`.
      (Required) `path` - The condition of HTTP request path. `path` block as defined below.
        (Required) `value` - The path pattern. The pattern must start with `/`.
        (Optional) `operator` - The operator that you want to use to determine whether an HTTP request path matches the conditions. Valid values are `EXACT`, `PREFIX`. Defaults to `PREFIX`.
        (Optional) `case_sensitive` - Whether to match the `value` condition using a case-sensitive match. Defaults to `false`.
      (Optional) `headers` - The condition of HTTP request headers. Each block of `headers` as defined below.
        (Required) `name` - The name of the HTTP header field.
        (Required) `value` - The value of the HTTP header field.
        (Optional) `operator` - The operator that you want to use to determine whether an HTTP header matches the conditions. Valid values are `EXACT`, `PREFIX`, `CONTAINS`. Defaults to `EXACT`.
        (Optional) `case_sensitive` - Whether to match the `value` condition using a case-sensitive match. Defaults to `false`.
    (Required) `action_type` - The action type for the rule of the service. Valid values are `FORWARD`, `FIXED_RESPONSE`.
    (Optional) `action_parameters` - The configuration for the parameters of the routing action. `action_parameters` block as defined below.
      (Optional) `status_code` - Custom HTTP status code to drop client requests and return a custom HTTP response. Valid values are `404`. Only supported if `action_type` is `FIXED_RESPONSE`.
      (Optional) `destinations` - A list of one or more target groups to route traffic. Only supported if `action_type` is `FORWARD`. Each item of `destinations` block as defined below.
        (Required) `target_group` - The ID or ARN of the target group to which to route traffic.
        (Optional) `weight` - The weight to use routing traffic to `target_group`. how requests are distributed to the target group. Only required if you specify multiple target groups for a forward action. For example, if you specify two target groups, one with a weight of 10 and the other with a weight of 20, the target group with a weight of 20 receives twice as many requests as the other target group. Valid value is `0` to `999`. Defaults to `100`.
  EOF
  type = list(object({
    priority = number
    name     = optional(string)

    conditions = object({
      method = optional(string)
      path = object({
        value          = string
        operator       = optional(string, "PREFIX")
        case_sensitive = optional(bool, false)
      })
      headers = optional(list(object({
        name           = string
        value          = string
        operator       = optional(string, "EXACT")
        case_sensitive = optional(bool, false)
      })), [])
    })

    action_type = string
    action_parameters = optional(object({
      status_code = optional(number, 404)
      destinations = optional(list(object({
        target_group = string
        weight       = optional(number, 100)
      })), [])
    }), {})
  }))
  default  = []
  nullable = false

  validation {
    condition = alltrue([
      for rule in var.rules :
      alltrue([
        rule.priority >= 1,
        rule.priority <= 100,
      ])
    ])
    error_message = "`priority` should be in the range (1 - 100)."
  }
  validation {
    condition = alltrue([
      for rule in var.rules :
      contains(["FORWARD", "FIXED_RESPONSE"], rule.action_type)
    ])
    error_message = "Valid values for `action_type` are `FORWARD` and `FIXED_RESPONSE`."
  }
  validation {
    condition = alltrue([
      for rule in var.rules :
      contains(["EXACT", "PREFIX"], rule.conditions.path.operator)
    ])
    error_message = "Valid values for `conditions.path.operator` are `EXACT` and `PREFIX`."
  }
  validation {
    condition = alltrue([
      for rule in var.rules :
      alltrue([
        for header in rule.conditions.headers :
        contains(["EXACT", "PREFIX", "CONTAINS"], header.operator)
      ])
    ])
    error_message = "Valid values for `conditions.headers[].operator` are `CONTAINS`, `EXACT` and `PREFIX`."
  }
  validation {
    condition = alltrue([
      for rule in var.rules :
      alltrue([
        rule.action_parameters.status_code >= 200,
        rule.action_parameters.status_code <= 599,
      ])
      if rule.action_type == "FIXED_RESPONSE"
    ])
    error_message = "Value of `action_parameter.status_code` should be 200 - 599."
  }
  validation {
    condition = alltrue([
      for rule in var.rules :
      alltrue([
        for destination in rule.action_parameters.destinations :
        alltrue([
          try(destination.weight, 1) >= 0,
          try(destination.weight, 1) <= 999,
        ])
      ])
      if rule.action_type == "FORWARD"
    ])
    error_message = "Value of `action_parameter.destinations[].weight` should be between 0 and 999."
  }
}

variable "tags" {
  description = "(Optional) A map of tags to add to all resources."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "module_tags_enabled" {
  description = "(Optional) Whether to create AWS Resource Tags for the module informations."
  type        = bool
  default     = true
  nullable    = false
}


###################################################
# Resource Group
###################################################




variable "resource_group" {
  description = <<EOF
  (Optional) A configurations of Resource Group for this module. `resource_group` as defined below.
    (Optional) `enabled` - Whether to create Resource Group to find and group AWS resources which are created by this module. Defaults to `true`.
    (Optional) `name` - The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. If not provided, a name will be generated using the module name and instance name.
    (Optional) `description` - The description of Resource Group. Defaults to `Managed by Terraform.`.
  EOF
  type = object({
    enabled     = optional(bool, true)
    name        = optional(string, "")
    description = optional(string, "Managed by Terraform.")
  })
  default  = {}
  nullable = false
}
