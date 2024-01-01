variable "name" {
  description = "(Required) The name of the Transit Gateway."
  type        = string
  nullable    = false
}

variable "description" {
  description = "(Optional) A description for the Transit Gateway."
  type        = string
  default     = "Managed by Terraform."
  nullable    = false
}

variable "asn" {
  description = "(Optional) The ASN(Autonomous System Number) to be configured on the Amazon side of a BGP session. Modifying `asn` on a Transit Gateway with active BGP sessions is not allowed. The ASN must be in the private range of `64512` to `65534` or `4200000000` to `4294967294`. Defaults to `64512.`"
  type        = number
  default     = 64512
  nullable    = false
}

variable "cidr_blocks" {
  description = "(Optional) A set of IPv4 or IPv6 CIDR blocks for the Transit Gateway. Must be a size /24 CIDR block or larger for IPv4, or a size /64 CIDR block or larger for IPv6."
  type        = set(string)
  default     = []
  nullable    = false
}

variable "default_association_route_table" {
  description = <<EOF
  (Optional) The configuration for the default association route table for automatic association. `default_association_route_table` block as defined below.
    (Optional) `enabled` - Whether to automatically associate transit gateway attachments with this transit gateway's default route table. Defaults to `false`.
  EOF
  type = object({
    enabled = optional(bool, false)
  })
  default  = {}
  nullable = false
}

variable "default_propagation_route_table" {
  description = <<EOF
  (Optional) The configuration for the default propagation route table for automatic propagation. `default_propagation_route_table` block as defined below.
    (Optional) `enabled` - Whether to automatically propagate transit gateway attachments with this transit gateway's default route table. Defaults to `false`.
  EOF
  type = object({
    enabled = optional(bool, false)
  })
  default  = {}
  nullable = false
}

variable "dns_support_enabled" {
  description = "(Optional) Whether to enable Domain Name System resolution for VPCs attached to this transit gateway. Defaults to `true`."
  type        = bool
  default     = true
  nullable    = false
}

variable "multicast_support_enabled" {
  description = "(Optional) Whether to enable the ability to create multicast domains in this transit gateway. Defaults to `false`."
  type        = bool
  default     = false
  nullable    = false
}

variable "vpn_ecmp_support_enabled" {
  description = "(Optional) Whether to enable Equal cost multipath (ECMP) routing for VPN Connections that are attached to this transit gateway. Defaults to `true`."
  type        = bool
  default     = true
  nullable    = false
}

variable "auto_accept_cross_account_attachments" {
  description = "(Optional) Whether to automatically accept cross-account attachments that are attached to this transit gateway. Defaults to `false`."
  type        = bool
  default     = false
  nullable    = false
}

# variable "allocation_settings" {
#   description = <<EOF
#   (Optional) The configuration for the settings that will be applied to any allocations within this IPAM pool. `allocation_settings` block as defined below.
#     (Optional) `auto_import` - Whether IPAM will continuously look for resources within the CIDR range of this pool and automatically import them as allocations into your IPAM. The CIDRs that will be allocated for these resources must not already be allocated to other resources in order for the import to succeed. IPAM will import a CIDR regardless of its compliance with the pool's allocation rules, so a resource might be imported and subsequently marked as noncompliant. If IPAM discovers multiple CIDRs that overlap, IPAM will import the largest CIDR only. If IPAM discovers multiple CIDRs with matching CIDRs, IPAM will randomly import one of them only. A locale must be set on the pool for this feature to work. Defaults to `false`.
#     (Optional) `required_resource_tags` - Tags required for resources that use CIDRs from this IPAM pool. Automatically imported resources that do not have these tags will be marked as noncompliant. Resources not automatically imported into the pool will not be allowed to allocate space from the pool unless they have these tags.
#     (Optional) `min_netmask_length` - The minimum subnet mask length required for CIDR allocations in this pool to be compliant.
#     (Optional) `default_netmask_length` - The default netmask length for allocations added to this pool.
#     (Optional) `max_netmask_length` - The maximum netmask length required for CIDR allocations in this pool to be compliant.
#   EOF
#   type = object({
#     auto_import = optional(bool, false)
#
#     required_resource_tags = optional(map(string), {})
#
#     min_netmask_length     = optional(number)
#     default_netmask_length = optional(number)
#     max_netmask_length     = optional(number)
#   })
#   default  = {}
#   nullable = false
# }
#
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


###################################################
# Resource Sharing by RAM (Resource Access Manager)
###################################################

variable "shares" {
  description = "(Optional) A list of resource shares via RAM (Resource Access Manager)."
  type = list(object({
    name = optional(string)

    permissions = optional(set(string), ["AWSRAMDefaultPermissionTransitGateway"])

    external_principals_allowed = optional(bool, false)
    principals                  = optional(set(string), [])

    tags = optional(map(string), {})
  }))
  default  = []
  nullable = false
}
