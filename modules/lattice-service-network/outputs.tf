output "id" {
  description = "The ID of the service network."
  value       = aws_vpclattice_service_network.this.id
}

output "arn" {
  description = "The ARN of the service network."
  value       = aws_vpclattice_service_network.this.arn
}

output "name" {
  description = "The name of the service network."
  value       = aws_vpclattice_service_network.this.name
}

output "auth_type" {
  description = "The type of authentication and authorization that manages client access to the service network."
  value       = aws_vpclattice_service_network.this.auth_type
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
  The list of Service associations with the service network.
    `id` - The ID of the association.
    `arn` - The ARN of the Association.
    `status` - The operations status. Valid Values are `CREATE_IN_PROGRESS`, `ACTIVE`, `DELETE_IN_PROGRESS`, `CREATE_FAILED`, `DELETE_FAILED`.
    `created_by` - The principal that created the association.

    `vpc` - The ID of the VPC.
    `security_groups` - A list of the IDs of the security groups.
  EOF
  value = {
    for name, association in aws_vpclattice_service_network_service_association.this :
    name => {
      id         = association.id
      arn        = association.arn
      status     = association.status
      created_by = association.created_by

      service = association.service
    }
  }
}

output "z" {
  value = aws_vpclattice_auth_policy.this
}
