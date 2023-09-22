variable "name" {
  description = "(Required) The name of the target group. The name must be unique within the account. The valid characters are a-z, 0-9, and hyphens (-). You can't use a hyphen as the first or last character, or immediately after another hyphen."
  type        = string
  nullable    = false
}

variable "vpc" {
  description = "(Required) The ID of the VPC which the target group belongs to."
  type        = string
  nullable    = false
}

variable "port" {
  description = "(Optional) The port on which the targets are listening. Valid values are from `1` to `65535`. "
  type        = number
  default     = null
  nullable    = true

  validation {
    condition = (var.port != null
      ? alltrue([
        var.port >= 1,
        var.port <= 65535,
      ])
      : true
    )
    error_message = "Valid values of `port` are 1-65535."
  }
}

variable "protocol" {
  description = "(Required) The protocol to use for routing traffic to the targets. Valid values are `HTTP` and `HTTPS`."
  type        = string
  nullable    = false

  validation {
    condition     = contains(["HTTP", "HTTPS"], var.protocol)
    error_message = "Valid values are `HTTP` and `HTTPS`."
  }
}

variable "protocol_version" {
  description = "(Optional) The protocol version. Valid Values are `HTTP1`, `HTTP2` and `GRPC`. Defaults to `HTTP1`."
  type        = string
  default     = "HTTP1"
  nullable    = false

  validation {
    condition     = contains(["HTTP1", "HTTP2", "GRPC"], var.protocol_version)
    error_message = "Valid values are `HTTP1`, `HTTP2` and `GRPC`."
  }
}

variable "targets" {
  description = <<EOF
  (Optional) A list of targets to add to the target group. Support only single ALB as target. Each value of `targets` block as defined below.
    (Required) `name` - The name of the target. This value is only used internally within Terraform code.
    (Required) `alb` - The Amazon Resource Name (ARN) of the target ALB (Application Load Balancer). The target should be internal Application Load Balancer.
    (Optional) `port` - The port on which the target is listening. If `port` is not specified and `protocol` is `HTTP`, the value will default to `80`. If `port` is not specified and `protocol` is `HTTPS`, the value will default to `443`.
  EOF
  type = list(object({
    name = string
    alb  = string
    port = optional(number)
  }))
  default  = []
  nullable = false

  validation {
    condition     = length(var.targets) < 2
    error_message = "Support only single ALB as target."
  }
  validation {
    condition = alltrue([
      for target in var.targets :
      alltrue([
        target.port >= 1,
        target.port <= 65535,
      ])
      if target.port != null
    ])
    error_message = "Valid values of `port` are 1-65535."
  }
}

variable "timeouts" {
  description = "(Optional) How long to wait for the target group to be created/deleted."
  type = object({
    create = optional(string, "5m")
    delete = optional(string, "5m")
  })
  default  = {}
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
