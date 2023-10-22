variable "name" {
  description = "(Required) The name of the target group. The name must be unique within the account. The valid characters are a-z, 0-9, and hyphens (-). You can't use a hyphen as the first or last character, or immediately after another hyphen."
  type        = string
  nullable    = false
}

variable "lambda_event_structure_version" {
  description = "(Optional) The version of the event structure that the Lambda function receives. Valid values are `V1` are `V2`. Defaults to `V2`."
  type        = string
  default     = "V2"
  nullable    = false

  validation {
    condition     = contains(["V1", "V2"], var.lambda_event_structure_version)
    error_message = "Valid values for `lambda_event_structure_version` are `V1` and `V2`."
  }
}

variable "targets" {
  description = <<EOF
  (Optional) A list of targets to add to the target group. Each value of `targets` block as defined below.
    (Required) `name` - The name of the target. This value is only used internally within Terraform code.
    (Required) `lambda_function` - The Amazon Resource Name (ARN) of the target Lambda function. If your ARN doesn't specify a version or alias, the latest version ($LATEST) is used by default. If the ARN specifies a version or alias, it appears as the last segment of the ARN separated by a colon.
  EOF
  type = list(object({
    name            = string
    lambda_function = string
  }))
  default  = []
  nullable = false

  validation {
    condition     = length(var.targets) < 2
    error_message = "Lambda target groups are limited to a single Lambda function target."
  }
}

variable "timeouts" {
  description = "(Optional) How long to wait for the target group to be created/deleted."
  type = object({
    create = optional(string, "5m")
    delete = optional(string, "5m")
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
