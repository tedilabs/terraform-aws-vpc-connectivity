variable "peering_connection" {
  description = <<EOF
  (Required) The information of the VPC Peering Connection to accept. The given filters must match exactly one VPC peering connection. `peering_connection` as defined below.
    (Optional) `id` - The VPC Peering Connection ID to manage.
    (Optional) `requester_vpc` - The information of the requester VPC. `requester_vpc` as defined below.
      (Optional) `id` - The ID of the requester VPC.
      (Optional) `region` - The region of the VPC with which you are creating the VPC Peering Connection.
      (Optional) `account` - The AWS account ID of the owner of the peer VPC.
    (Optional) `accepter_vpc` - The information of the accepter VPC. `accepter_vpc` as defined below.
      (Optional) `id` - The ID of the accepter VPC.
  account.
  EOF
  type = object({
    id = optional(string)
    requester_vpc = optional(object({
      id      = optional(string)
      region  = optional(string)
      account = optional(string)

      ipv4_cidr = optional(string)
    }), {})
    accepter_vpc = optional(object({
      id = optional(string)

      ipv4_cidr = optional(string)
    }), {})
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
