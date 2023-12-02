variable "peering_connection" {
  description = <<EOF
  (Required) The information of the VPC Peering Connection to accept. The given filters must match exactly one VPC peering connection. `peering_connection` as defined below.
    (Optional) `id` - The VPC Peering Connection ID to manage.
  account.
  EOF
  type = object({
    id = optional(string)
  })
  nullable = false
}

variable "name" {
  description = "(Required) Desired name for the VPC Peering resources."
  type        = string
  nullable    = false
}

variable "allow_remote_vpc_dns_resolution" {
  description = "(Optional) Whether to allow a accepter VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the requester VPC. Defaults to `false`."
  type        = bool
  default     = false
  nullable    = false
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
