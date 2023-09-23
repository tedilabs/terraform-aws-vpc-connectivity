variable "name" {
  description = "(Required) The name of the service."
  type        = string
  nullable    = false
}

variable "service_network_associations" {
  description = <<EOF
  (Optional) The configuration for the service network associations with the service. To facilitate network client access to your service, you will need to associate your service to the relevant service networks. Only service networks created in the same account, or that have been shared with you (by way of Resource Access Manager), are available for you to create associations with. Each block of `service_network_associations` as defined below.
    (Required) `name` - The name of the service association.
    (Required) `service_network` - The ID or ARN (Amazon Resource Name) of the service network.
    (Optional) `tags` - A map of tags to add to the service association.
  EOF
  type = list(object({
    name            = string
    service_network = string
    tags            = optional(map(string), {})
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
