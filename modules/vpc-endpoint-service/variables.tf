variable "region" {
  description = "(Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region."
  type        = string
  default     = null
  nullable    = true
}

variable "name" {
  description = "(Required) Desired name for the VPC Endpoint Service."
  type        = string
  nullable    = false
}

variable "type" {
  description = "(Required) A load balancer type for the VPC Endpoint Service. Valid values are `GWLB` and `NLB`."
  type        = string
  nullable    = false

  validation {
    condition     = contains(["GWLB", "NLB"], var.type)
    error_message = "Valid values for type are `GWLB` and `NLB`."
  }
}

variable "load_balancers" {
  description = "(Required) A list of Amazon Resource Names of Network Load Balancers or Gateway Load Balancers for the endpoint service."
  type        = list(string)
  nullable    = false

  validation {
    condition     = length(var.load_balancers) > 0
    error_message = "At least one load balancer must be specified."
  }
}

variable "private_domain" {
  description = "(Optional) The private domain name for the service. This option allows users of endpoints to use the specified private DNS name for access the service from their VPCs."
  type        = string
  default     = null
  nullable    = true
}

variable "acceptance_required" {
  description = "(Optional) Whether or not VPC endpoint connection requests to the service must be accepted by the service owner. Defaults to `false`."
  type        = bool
  default     = false
  nullable    = false
}

variable "supported_ip_address_types" {
  description = "(Optional) The supported IP address types. Valid values are `IPv4` and `IPv6`."
  type        = set(string)
  default     = []
  nullable    = false

  validation {
    condition = alltrue([
      for ip_address_type in var.supported_ip_address_types :
      contains(["IPv4", "IPv6"], ip_address_type)
    ])
    error_message = "Valid values for ip address type are `IPv4` and `IPv6`."
  }
}

variable "supported_regions" {
  description = "(Optional) A set of supported AWS regions from which service consumers can access the service."
  type        = set(string)
  default     = []
  nullable    = false
}

variable "allowed_principals" {
  description = "(Optional) A list of the ARNs of principal to allow to discover a VPC endpoint service."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "connection_notifications" {
  description = <<EOF
  (Optional) A list of configurations of Endpoint Connection Notifications for VPC Endpoint Service events. Each block of `connection_notifications` as defined below.
    (Required) `name` - The name of the configuration for connection notification. This value is only used internally within Terraform code.
    (Required) `sns_topic` - The Amazon Resource Name (ARN) of the SNS topic for the notifications.
    (Required) `events` - One or more endpoint events for which to receive notifications. Valid values are `Accept`, `Reject`, `Connect` and `Delete`.
  EOF
  type = list(object({
    name      = string
    sns_topic = string
    events    = set(string)
  }))
  default  = []
  nullable = false

  validation {
    condition = alltrue([
      for notification in var.connection_notifications :
      alltrue([
        for event in notification.events :
        contains(["Accept", "Reject", "Connect", "Delete"], event)
      ])
    ])
    error_message = "Valid values for `events` of each notifications are `Accept`, `Reject`, `Connect` and `Delete`."
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
