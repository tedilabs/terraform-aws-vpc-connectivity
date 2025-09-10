output "id" {
  description = "The ID of the service network."
  value       = data.aws_vpclattice_service_network.this.id
}

output "arn" {
  description = "The ARN of the service network."
  value       = data.aws_vpclattice_service_network.this.arn
}

output "name" {
  description = "The name of the service network."
  value       = data.aws_vpclattice_service_network.this.name
}

output "auth_type" {
  description = "The type of authentication and authorization that manages client access to the service network."
  value       = data.aws_vpclattice_service_network.this.auth_type
}

output "vpc_associations" {
  description = <<EOF
  The list of VPC associations with the service network.
    `id` - The ID of the association.
    `arn` - The ARN of the Association.
    `status` - The operations status. Valid Values are `CREATE_IN_PROGRESS`, `ACTIVE`, `DELETE_IN_PROGRESS`, `CREATE_FAILED`, `DELETE_FAILED`.
    `created_by` - The principal that created the association.

    `vpc` - The ID of the VPC.
    `security_groups` - A list of the IDs of the security groups.
  EOF
  value = {
    for vpc, association in aws_vpclattice_service_network_vpc_association.this :
    vpc => {
      id         = association.id
      arn        = association.arn
      status     = association.status
      created_by = association.created_by

      vpc             = vpc
      security_groups = association.security_group_ids
    }
  }
}

output "service_associations" {
  description = <<EOF
  The list of the service associations with the service network.
    `id` - The ID of the association.
    `arn` - The ARN of the Association.
    `status` - The operations status. Valid Values are `CREATE_IN_PROGRESS`, `ACTIVE`, `DELETE_IN_PROGRESS`, `CREATE_FAILED`, `DELETE_FAILED`.
    `created_by` - The principal that created the association.

    `service` - The ARN (Amazon Resource Name) of the service.
  EOF
  value = {
    for name, association in aws_vpclattice_service_network_service_association.this :
    name => {
      id         = association.id
      arn        = association.arn
      status     = association.status
      created_by = association.created_by

      service = association.service_identifier

      domain        = one(association.dns_entry[*].domain_name)
      zone_id       = one(association.dns_entry[*].hosted_zone_id)
      custom_domain = association.custom_domain_name
    }
  }
}

output "created_at" {
  description = "Date and time that the service network was created, specified in ISO-8601 format."
  value       = data.aws_vpclattice_service_network.this.created_at
}

output "updated_at" {
  description = "Date and time that the service network was last updated, specified in ISO-8601 format."
  value       = data.aws_vpclattice_service_network.this.last_updated_at
}

output "resource_group" {
  description = "The resource group created to manage resources in this module."
  value = merge(
    {
      enabled = var.resource_group.enabled && var.module_tags_enabled
    },
    (var.resource_group.enabled && var.module_tags_enabled
      ? {
        arn  = module.resource_group[0].arn
        name = module.resource_group[0].name
      }
      : {}
    )
  )
}
