variable "transit_gateway" {
  description = "(Required) The ID of the Transit Gateway."
  type        = string
  nullable    = false

  validation {
    condition     = startswith(var.transit_gateway, "tgw-")
    error_message = "Valid value for `transit_gateway` must be the ID of the Transit Gateway."
  }
}

variable "name" {
  description = "(Required) The name of the Transit Gateway route table."
  type        = string
  nullable    = false
}

variable "attachment_associations" {
  description = <<EOF
  (Optional) A list of attachment association configurations for the Transit Gateway route table. Each block of `attachment_associations` as defined below.
    (Optional) `id` - The ID of the attachment association configuration. This value is only used internally within Terraform code.
    (Required) `attachment` - The ID of the attachment to associate.
  EOF
  type = list(object({
    id         = optional(string)
    attachment = string
  }))
  default  = []
  nullable = false
}

variable "attachment_route_propagations" {
  description = <<EOF
  (Optional) A list of route propagation configurations for the Transit Gateway route table. Each block of `attachment_route_propagations` as defined below.
    (Optional) `id` - The ID of the route propagation configuration. This value is only used internally within Terraform code.
    (Required) `attachment` - The ID of the attachment.
  EOF
  type = list(object({
    id         = optional(string)
    attachment = string
  }))
  default  = []
  nullable = false
}

variable "prefix_list_routes" {
  description = <<EOF
  (Optional) A list of route rules for destinations to Prefix Lists. Each block of `prefix_list_routes` as defined below.
    (Optional) `id` - The ID of the route rule. This value is only used internally within Terraform code.
    (Required) `destination` - The destination Prefix List of the route rule.
    (Optional) `target` - The ID of the attachment. If not specified, the route rule will be blackhole. Blackhole routes indicate whether traffic matching the route is to be dropped.
  EOF
  type = list(object({
    id          = optional(string)
    destination = string
    target      = optional(string)
  }))
  default  = []
  nullable = false
}

variable "static_routes" {
  description = <<EOF
  (Optional) A list of static route rules for destinations to IPv4 / IPv6 CIDRs. Each block of `static_routes` as defined below.
    (Required) `destination` - The destination IPv4 / IPv6 CIDR block of the route rule. For example, `10.0.0.0/16`, `::/8`.
    (Optional) `target` - The ID of the attachment. If not specified, the route rule will be blackhole. Blackhole routes indicate whether traffic matching the route is to be dropped.
  EOF
  type = list(object({
    destination = string
    target      = optional(string)
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
