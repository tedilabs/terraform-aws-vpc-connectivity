variable "name" {
  description = "(Required) The name of the service network."
  type        = string
  nullable    = false
}

variable "auth_type" {
  description = <<EOF
  (Optional) The type of authentication and authorization that manages client access to the service network. Valid values are `AWS_IAM` or `NONE`. Defaults to `NONE`.
    `NONE` - The service network will not authenticate or authorize client access. If an auth policy is present, it is inactive. Resources within associated VPCs will have access to services in this network, unless service-level policies restrict access.
    `AWS_IAM` - Applies an IAM resource policy on the service network. This provides administrators the ability to enforce authentication and write fine-grained permissions for the services in the network.
  EOF
  type        = string
  default     = "NONE"
  nullable    = false

  validation {
    condition     = contains(["AWS_IAM", "NONE"], var.auth_type)
    error_message = "Valid values for `auth_type` are `AWS_IAM` or `NONE`."
  }
}

variable "auth_policy" {
  description = <<EOF
  (Optional) The auth policy. Authorization decisions are made based on this policy, the service-level policy (if present), and IAM permissions attached to the client identity (if referencing IAM identities in this policy). The policy string in JSON must not contain newlines or blank lines.
  EOF
  type        = string
  default     = null
  nullable    = true

  validation {
    condition     = var.auth_policy == null || can(jsondecode(var.auth_policy))
    error_message = "The policy string in JSON must not contain newlines or blank lines."
  }
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
  (Optional) The configuration for Service associations with the service network. It enables all the resources within that VPC to be clients and communicate with other services in the service network. Each block of `vpc_associations` as defined below.
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
