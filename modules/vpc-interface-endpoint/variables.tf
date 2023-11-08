variable "name" {
  description = "(Required) Desired name for the VPC Interface Endpoint."
  type        = string
  nullable    = false
}

variable "service_name" {
  description = "(Required) The service name. For AWS services the service name is usually in the form `com.amazonaws.<region>.<service>`."
  type        = string
  nullable    = false
}

variable "auto_accept" {
  description = "(Optional) Accept the VPC endpoint (the VPC endpoint and service need to be in the same AWS account)."
  type        = bool
  default     = true
  nullable    = false
}

variable "vpc_id" {
  description = "(Required) The ID of the VPC in which the endpoint will be used."
  type        = string
  nullable    = false
}

variable "network_mapping" {
  description = <<EOF
  (Optional) The configuration for the interface endpoint how routes traffic to targets in which subnets, and in accordance with IP address settings. Choose one subnet for each zone. An endpoint network interface is assigned a private IP address from the IP address range of your subnet, and keeps this IP address until the interface endpoint is deleted. Each key of `network_mapping` is the availability zone id like `apne2-az1`, `use1-az1`. Each block of `network_mapping` as defined below.
    (Required) `subnet` - The id of the subnet of which to attach to the endpoint. You can specify only one subnet per Availability Zone.
  EOF
  type = map(object({
    subnet = string
  }))
  default  = {}
  nullable = false
}

variable "ip_address_type" {
  description = "(Optional) The type of IP addresses used by the subnets for the interface endpoint. The possible values are `IPV4`, `IPV6` and `DUALSTACK`. Defaults to `IPV4`"
  type        = string
  default     = "IPV4"
  nullable    = false

  validation {
    condition     = contains(["IPV4", "IPV6", "DUALSTACK"], var.ip_address_type)
    error_message = "The possible values are `IPV4`, `IPV6` and `DUALSTACK`."
  }
}

variable "private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC."
  type        = bool
  default     = false
  nullable    = false
}

variable "default_security_group" {
  description = <<EOF
  (Optional) The configuration of the default security group for the interface endpoint. `default_security_group` block as defined below.
    (Optional) `enabled` - Whether to use the default security group. Defaults to `true`.
    (Optional) `name` - The name of the default security group. If not provided, the endpoint name is used for the name of security group.
    (Optional) `description` - The description of the default security group.
    (Optional) `ingress_rules` - A list of ingress rules in a security group. You don't need to specify `protocol`, `from_port`, `to_port`. Just specify source information. Defaults to `[{ id = "default", ipv4_cidrs = ["0.0.0.0/0"] }]`. Each block of `ingress_rules` as defined below.
      (Optional) `id` - The ID of the ingress rule. This value is only used internally within Terraform code.
      (Optional) `description` - The description of the rule.
      (Optional) `protocol` - The protocol to match. Note that if `protocol` is set to `-1`, it translates to all protocols, all port ranges, and `from_port` and `to_port` values should not be defined. Defaults to `tcp`.
      (Optional) `from_port` - The start of port range for the TCP protocols. Defaults to `443`.
      (Optional) `to_port` - The end of port range for the TCP protocols. Defaults to `443`.
      (Optional) `ipv4_cidrs` - The IPv4 network ranges to allow, in CIDR notation.
      (Optional) `ipv6_cidrs` - The IPv6 network ranges to allow, in CIDR notation.
      (Optional) `prefix_lists` - The prefix list IDs to allow.
      (Optional) `security_groups` - The source security group IDs to allow.
      (Optional) `self` - Whether the security group itself will be added as a source to this ingress rule.
  EOF
  type = object({
    enabled     = optional(bool, true)
    name        = optional(string)
    description = optional(string, "Managed by Terraform.")
    ingress_rules = optional(
      list(object({
        id              = string
        description     = optional(string, "Managed by Terraform.")
        protocol        = optional(string)
        from_port       = optional(number)
        to_port         = optional(number)
        ipv4_cidrs      = optional(list(string), [])
        ipv6_cidrs      = optional(list(string), [])
        prefix_lists    = optional(list(string), [])
        security_groups = optional(list(string), [])
        self            = optional(bool, false)
      })),
      [{
        id         = "default"
        ipv4_cidrs = ["0.0.0.0/0"]
      }]
    )
  })
  default  = {}
  nullable = false
}

variable "security_groups" {
  description = "(Optional) A list of security group IDs to associate with the endpoint."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "policy" {
  description = "(Optional) A policy to attach to the endpoint that controls access to the service. This is a JSON formatted string. Defaults to full access. All Gateway and some Interface endpoints support policies."
  type        = string
  default     = null
  nullable    = true
}

variable "connection_notifications" {
  description = <<EOF
  (Optional) A list of configurations of Endpoint Connection Notifications for VPC Endpoint events. Each block of `connection_notifications` as defined below.
    (Required) `name` - The name of the configuration for connection notification. This value is only used internally within Terraform code.
    (Required) `sns_topic` - The Amazon Resource Name (ARN) of the SNS topic for the notifications.
    (Required) `events` - One or more endpoint events for which to receive notifications. Valid values are `Accept`, `Reject`, `Connect` and `Delete`.
  EOF
  type = list(object({
    name      = string
    sns_topic = string
    events    = set(string)
  }))
  default  = []
  nullable = false

  validation {
    condition = alltrue([
      for notification in var.connection_notifications :
      alltrue([
        for event in notification.events :
        contains(["Accept", "Reject", "Connect", "Delete"], event)
      ])
    ])
    error_message = "Valid values for `events` of each notifications are `Accept`, `Reject`, `Connect` and `Delete`."
  }
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
