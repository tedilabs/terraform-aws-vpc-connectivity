variable "id" {
  description = "(Required) The ID of the service network."
  type        = string
  nullable    = false
}

variable "vpc_associations" {
  description = <<EOF
  (Optional) The configuration for VPC associations with the service network. It enables all the resources within that VPC to be clients and communicate with other services in the service network. Each block of `vpc_associations` as defined below.
    (Required) `vpc` - The ID of the VPC.
    (Optional) `security_groups` - A list of the IDs of the security groups.
    (Optional) `tags` - A map of tags to add to the vpc association.
  EOF
  type = list(object({
    vpc             = string
    security_groups = optional(set(string), [])
    tags            = optional(map(string), {})
  }))
  default  = []
  nullable = false
}

variable "service_associations" {
  description = <<EOF
  (Optional) The configuration for the service associations with the service network. To facilitate network client access to your service, you will need to associate your service to the relevant service networks. Only service networks created in the same account, or that have been shared with you (by way of Resource Access Manager), are available for you to create associations with. Each block of `service_associations` as defined below.
    (Required) `name` - The name of the service association.
    (Required) `service` - The ID or ARN (Amazon Resource Name) of the service.
    (Optional) `tags` - A map of tags to add to the service association.
  EOF
  type = list(object({
    name    = string
    service = string
    tags    = optional(map(string), {})
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
