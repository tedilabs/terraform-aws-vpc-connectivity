variable "name" {
  description = "(Required) Desired name for the VPC Gateway Endpoint."
  type        = string
  nullable    = false
}

variable "service" {
  description = "(Required) The AWS service name. Valid values are `DYNAMODB`, `S3`, `S3EXPRESS`."
  type        = string
  nullable    = false

  validation {
    condition     = contains(["DYNAMODB", "S3", "S3EXPRESS"], var.service)
    error_message = "Valid values are `DYNAMODB`, `S3` and `S3EXPRESS`."
  }
}

variable "vpc_id" {
  description = "(Required) The ID of the VPC in which the endpoint will be used."
  type        = string
  nullable    = false
}

variable "policy" {
  description = "(Optional) A policy to attach to the endpoint that controls access to the service. This is a JSON formatted string. Defaults to full access. All Gateway endpoints support policies."
  type        = string
  default     = null
  nullable    = true
}

variable "route_tables" {
  description = <<EOF
  (Optional) A list of route table IDs to associate with the endpoint.
  EOF
  type        = list(string)
  default     = []
  nullable    = false
}

variable "timeouts" {
  description = "(Optional) How long to wait for the endpoint to be created/updated/deleted."
  type = object({
    create = optional(string, "10m")
    update = optional(string, "10m")
    delete = optional(string, "10m")
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
