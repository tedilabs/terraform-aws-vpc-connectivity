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
      tonumber(try(var.default_action_parameters.status_code, 404)) >= 200,
      tonumber(try(var.default_action_parameters.status_code, 404)) <= 599,
    ])
    error_message = "Value of `status_code` should be 200 - 599."
  }
  validation {
    condition = alltrue([
      for destination in try(var.default_action_parameters.destinations, []) :
      alltrue([
        try(destination.weight, 1) >= 0,
        try(destination.weight, 1) <= 999,
      ])
    ])
    error_message = "Value of `destinations[].weight` should be between 0 and 999."
  }
}

# TODO: Update Docs
# TODO: Support Match
variable "rules" {
  description = <<EOF
  (Optional) The configuration for the parameters of the default routing action. `default_action_parameters` block as defined below.
    (Optional) `status_code` - The status code of HTTP response. Valid values are `2XX`, `4XX`, or `5XX`. Defaults to `503`. Only supported if `default_action_type` is `FIXED_RESPONSE`.
    (Required) `targets` - A list of target configurations to route traffic. To route to a single target group, use `default_action_type` as `FORWARD`. Only supported if `default_action_type` is `WEIGHTED_FORWARD`. Each item of `targets` block as defined below.
      (Required) `target_group` - The ARN of the target group to which to route traffic.
      (Optional) `weight` - The weight to use routing traffic to `target_group`. Valid value is `0` to `999`. Defaults to `1`.
  EOF
  type = list(object({
    priority = number
    name     = optional(string)

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

variable "resource_group_enabled" {
  description = "(Optional) Whether to create Resource Group to find and group AWS resources which are created by this module."
  type        = bool
  default     = true
  nullable    = false
}

variable "resource_group_name" {
  description = "(Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`."
  type        = string
  default     = ""
  nullable    = false
}

variable "resource_group_description" {
  description = "(Optional) The description of Resource Group."
  type        = string
  default     = "Managed by Terraform."
  nullable    = false
}
