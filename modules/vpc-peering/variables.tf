variable "name" {
  description = "(Required) Desired name for the VPC Peering resources."
  type        = string
  nullable    = false
}

variable "requester_vpc" {
  description = <<EOF
  (Required) The configuration of the requester VPC. `requester_vpc` as defined below.
    (Required) `id` - The ID of the requester VPC.
  account.
  EOF
  type = object({
    id = string
  })
  nullable = false
}

variable "requester_options" {
  description = <<EOF
  (Optional) The requester options of the VPC Peering Connection. `requester_options` as defined below.
    (Optional) `allow_remote_vpc_dns_resolution` - Whether to allow a requester VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the accepter VPC. Defaults to `false`.
  account.
  EOF
  type = object({
    allow_remote_vpc_dns_resolution = optional(bool, false)
  })
  default  = {}
  nullable = false
}

variable "accepter_vpc" {
  description = <<EOF
  (Required) The configuration of the accepter VPC. `accepter_vpc` as defined below.
    (Required) `id` - The ID of the VPC with which you are creating the VPC Peering Connection.
  account.
  EOF
  type = object({
    id = string
  })
  nullable = false
}

variable "accepter_options" {
  description = <<EOF
  (Optional) The accepter options of the VPC Peering Connection. `accepter_options` as defined below.
    (Optional) `allow_remote_vpc_dns_resolution` - Whether to allow a accepter VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the requester VPC. Defaults to `false`.
  account.
  EOF
  type = object({
    allow_remote_vpc_dns_resolution = optional(bool, false)
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
