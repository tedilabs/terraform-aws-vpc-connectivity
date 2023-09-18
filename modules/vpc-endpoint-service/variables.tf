variable "name" {
  description = "(Required) Desired name for the VPC Endpoint Service."
  type        = string
  nullable    = false
}

variable "gateway_load_balancers" {
  description = "(Optional) A list of Amazon Resource Names of one or more Gateway Load Balancers for the endpoint service."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "network_load_balancers" {
  description = "(Optional) A list of Amazon Resource Names of one or more Network Load Balancers for the endpoint service."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "private_domain" {
  description = "(Optional) The private domain name for the service."
  type        = string
  default     = null
}

variable "acceptance_required" {
  description = "(Optional) Whether or not VPC endpoint connection requests to the service must be accepted by the service owner. Defaults to `false`."
  type        = bool
  default     = false
  nullable    = false
}

variable "supported_ip_address_types" {
  description = "(Optional) The supported IP address types. Valid values are `IPV4` and `IPV6`."
  type        = bool
  default     = false
  nullable    = false

  validation {
    condition = alltrue([
      for t in var.supported_ip_address_types :
      contains(["IPV4", "IPV6"], t)
    ])
    error_message = "Valid values for ip address type are `IPV4` and `IPV6`."
  }
}

variable "allowed_principals" {
  description = "(Optional) A list of the ARNs of principal to allow to discover a VPC endpoint service."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "notification_configurations" {
  description = "(Optional) A list of configurations of Endpoint Connection Notifications for VPC Endpoint events."
  type = list(object({
    sns_arn = string
    events  = list(string)
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
