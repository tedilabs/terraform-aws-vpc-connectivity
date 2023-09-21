variable "name" {
  description = "(Required) The name of the service network. The name must be between 3 and 63 characters. You can use lowercase letters, numbers, and hyphens. The name must begin and end with a letter or number. Do not use consecutive hyphens."
  type        = string
  nullable    = false

  validation {
    condition = alltrue([
      length(var.name) >= 3,
      length(var.name) <= 63,
    ])
    error_message = "The name must be between 3 and 63 characters."
  }
  # INFO: Not support negative lookahead
  # validation {
  #   condition     = regex("^(?![-])(?!.*[-]$)(?!.*[-]{2})[a-z0-9-]+$", var.name)
  #   error_message = "The name must satisfy regular expression pattern: `^(?![-])(?!.*[-]$)(?!.*[-]{2})[a-z0-9-]+$`."
  # }
}


variable "description" {
  description = "(Optional) The description of the service network. This creates a tag with a key of `Description` and a value that you specify."
  type        = string
  default     = "Managed by Terraform."
  nullable    = false
}

variable "policy" {
  description = <<EOF
  (Optional) A resource-based permission policy for the service network. The policy must contain the same actions and condition statements as the Amazon Web Services Resource Access Manager permission for sharing services and service networks.
  EOF
  type        = string
  default     = null
  nullable    = true

  validation {
    condition     = var.policy == null || can(jsondecode(var.policy))
    error_message = "The policy string in JSON must not contain newlines or blank lines."
  }
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

variable "logging_to_cloudwatch" {
  description = <<EOF
  (Optional) The configuration to enable access logs to be sent to Amazon CloudWatch Log Group. The service network owner can use the access logs to audit the services in the network. The service network owner will only see access logs from clients and services that are associated with their service network. Access log entries represent traffic originated from VPCs associated with that network. `logging_to_cloudwatch` as defined below.
    (Optional) `enabled` - Whether to enable access logs to be sent to Amazon CloudWatch Log Group.
    (Optional) `log_group` - The ARN (Amazon Resource Name) of the CloudWatch Log Group.
  EOF
  type = object({
    enabled   = optional(bool, false)
    log_group = optional(string, "")
  })
  default  = {}
  nullable = false

  validation {
    condition = anytrue([
      var.logging_to_cloudwatch.enabled == false,
      var.logging_to_cloudwatch.enabled && startswith(var.logging_to_cloudwatch.log_group, "arn:aws:logs:"),
    ])
    error_message = "Valid value for `log_group` must be the ARN (Amazon Resource Name) of the CloudWatch Log Group."
  }
}

variable "logging_to_kinesis_data_firehose" {
  description = <<EOF
  (Optional) The configuration to enable access logs to be sent to Amazon Kinesis Data Firehose. The service network owner can use the access logs to audit the services in the network. The service network owner will only see access logs from clients and services that are associated with their service network. Access log entries represent traffic originated from VPCs associated with that network. `logging_to_kinesis_data_firehose` as defined below.
    (Optional) `enabled` - Whether to enable access logs to be sent to Amazon Kinesis Data
  Firehose.
    (Optional) `delivery_stream` - The ARN (Amazon Resource Name) of the Kinesis Data Firehose
  delivery stream.
  EOF
  type = object({
    enabled         = optional(bool, false)
    delivery_stream = optional(string, "")
  })
  default  = {}
  nullable = false

  validation {
    condition = anytrue([
      var.logging_to_kinesis_data_firehose.enabled == false,
      var.logging_to_kinesis_data_firehose.enabled && startswith(var.logging_to_kinesis_data_firehose.delivery_stream, "arn:aws:firehose:"),
    ])
    error_message = "Valid value for `delivery_stream` must be the ARN (Amazon Resource Name) of the Kinesis Data Firehose Delivery Stream."
  }
}

variable "logging_to_s3" {
  description = <<EOF
  (Optional) The configuration to enable access logs to be sent to Amazon S3 Bucket. The service network owner can use the access logs to audit the services in the network. The service network owner will only see access logs from clients and services that are associated with their service network. Access log entries represent traffic originated from VPCs associated with that network. `logging_to_s3` as defined below.
    (Optional) `enabled` - Whether to enable access logs to be sent to Amazon S3 Bucket.
    (Optional) `bucket` - The ARN (Amazon Resource Name) of the S3 Bucket.
  EOF
  type = object({
    enabled = optional(bool, false)
    bucket  = optional(string, "")
  })
  default  = {}
  nullable = false

  validation {
    condition = anytrue([
      var.logging_to_s3.enabled == false,
      var.logging_to_s3.enabled && startswith(var.logging_to_s3.bucket, "arn:aws:s3:"),
    ])
    error_message = "Valid value for `bucket` must be the ARN (Amazon Resource Name) of the S3 Bucket."
  }
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


###################################################
# Resource Sharing by RAM (Resource Access Manager)
###################################################

variable "shares" {
  description = "(Optional) A list of resource shares via RAM (Resource Access Manager)."
  type = list(object({
    name = optional(string)

    permissions = optional(set(string), ["AWSRAMPermissionVpcLatticeServiceNetworkReadWrite"])

    external_principals_allowed = optional(bool, false)
    principals                  = optional(set(string), [])

    tags = optional(map(string), {})
  }))
  default  = []
  nullable = false
}
