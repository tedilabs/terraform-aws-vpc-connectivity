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

variable "ip_address_type" {
  description = "(Optional) The type of IP addresses used for the target group. Valid values are `IPV4` or `IPV6`. Defaults to `IPV4`."
  type        = string
  default     = "IPV4"
  nullable    = false

  validation {
    condition     = contains(["IPV4", "IPV6"], var.ip_address_type)
    error_message = "Valid values are `IPV4` or `IPV6`."
  }
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

variable "health_check" {
  description = <<EOF
  (Optional) The health check configuration of the target group. The associated service periodically sends requests according to this configuration to the registered targets to test their status. `health_check` block as defined below.
    (Optional) `enabled` - Whether to enable health check. Defaults to `true`.
    (Optional) `protocol` - The protocol used when performing health checks on targets. Valid values are `HTTP` and `HTTPS`. Defaults to `HTTP`.
    (Optional) `protocol_version` - The protocol version used when performing health checks on targets. Valid values are `HTTP1` and `HTTP2`. Defaults to `HTTP1`.
    (Optional) `port` - The port used when performing health checks on targets. The default setting is the port that a target receives traffic on.
    (Optional) `path` - The destination for health checks on the targets. If the protocol version is HTTP/1.1 or HTTP/2, specify a valid URI (for example, `/path?query`). Health checks are not supported if the protocol version is gRPC, however, you can choose HTTP/1.1 or HTTP/2 and specify a valid URI. The maximum length is 1024 characters. Defaults to `/`.
    (Optional) `success_codes` - The HTTP codes to use when checking for a successful response from a target. You can specify multiple values (for example, `200,202`) or a range of values (for example, `200-299`). Defaults to `200-299`.
    (Optional) `interval` - The approximate amount of time between health checks of an individual target. Valid value range is 5 - 300. Defaults to `30`.
    (Optional) `timeout` - The amount of time, in seconds, during which no response means a failed health check. Valid value range is 1 - 120. Defaults to `5`.
    (Optional) `healthy_threshold` - The number of consecutive successful health checks required before an unhealthy target is considered healthy. Valid value range is 2 - 10. Defaults to `5`.
    (Optional) `unhealthy_threshold` - The number of consecutive health check failures required before considering a target unhealthy. Valid value range is 2 - 10. Defaults to `2`.
  EOF
  type = object({
    enabled = optional(bool, true)

    port             = optional(number)
    protocol         = optional(string, "HTTP")
    protocol_version = optional(string, "HTTP1")
    path             = optional(string, "/")

    success_codes = optional(string, "200-299")

    interval = optional(number, 30)
    timeout  = optional(number, 5)

    healthy_threshold   = optional(number, 5)
    unhealthy_threshold = optional(number, 2)
  })
  default  = {}
  nullable = false

  validation {
    condition     = contains(["HTTP", "HTTPS"], var.health_check.protocol)
    error_message = "Valid values for `protocol` are `HTTP` and `HTTPS`."
  }
  validation {
    condition     = contains(["HTTP1", "HTTP2"], var.health_check.protocol_version)
    error_message = "Valid values for `protocol_version` are `HTTP1` and `HTTP2`."
  }
  validation {
    condition = alltrue([
      startswith(var.health_check.path, "/"),
      length(var.health_check.path) <= 1024,
    ])
    error_message = "Valid value for `path` is a valid URI (for example, `/path?query`). The maximum length is 1024 characters."
  }
  validation {
    condition = alltrue([
      var.health_check.interval >= 5,
      var.health_check.interval <= 300,
    ])
    error_message = "Valid value range for `interval` is 5 - 300."
  }
  validation {
    condition = alltrue([
      var.health_check.timeout >= 1,
      var.health_check.timeout <= 120,
    ])
    error_message = "Valid value range for `timeout` is 1 - 120."
  }
  validation {
    condition = alltrue([
      var.health_check.healthy_threshold <= 10,
      var.health_check.healthy_threshold >= 2,
    ])
    error_message = "Valid value range for `healthy_threshold` is 2 - 10."
  }
  validation {
    condition = alltrue([
      var.health_check.unhealthy_threshold <= 10,
      var.health_check.unhealthy_threshold >= 2,
    ])
    error_message = "Valid value range for `unhealthy_threshold` is 2 - 10."
  }
}

variable "targets" {
  description = <<EOF
  (Optional) A list of targets to add to the target group. Each value of `targets` block as defined below.
    (Required) `name` - The name of the target. This value is only used internally within Terraform code.
    (Required) `ip_address` - This is an IP address for the target.
    (Optional) `port` - The port on which the target is listening. If `port` is not specified and `protocol` is `HTTP`, the value will default to `80`. If `port` is not specified and `protocol` is `HTTPS`, the value will default to `443`.
  EOF
  type = list(object({
    name       = string
    ip_address = string
    port       = optional(number)
  }))
  default  = []
  nullable = false

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
