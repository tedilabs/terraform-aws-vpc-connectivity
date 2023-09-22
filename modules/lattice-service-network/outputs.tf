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

output "description" {
  description = "The description of the service network."
  value       = var.description
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

output "logging" {
  description = <<EOF
  The configuration for access logs of the service network.
  Firehose Delivery Stream, Amazon S3 Bucket.
    `cloudwatch` - The configuration for access logs to be sent to Amazon CloudWatch Log Group.
    `kinesis_data_firehose` - The configuration for access logs to be sent to Amazon Kinesis Data
  Firehose Delivery Stream.
    `s3` - The configuration for access logs to be sent to Amazon S3 BUcket.
  EOF
  value = {
    cloudwatch = one([
      for subscription in aws_vpclattice_access_log_subscription.cloudwatch : {
        enabled   = var.logging_to_cloudwatch.enabled
        id        = subscription.id
        arn       = subscription.arn
        log_group = subscription.destination_arn
      }
    ])
    kinesis_data_firehose = one([
      for subscription in aws_vpclattice_access_log_subscription.kinesis_data_firehose : {
        enabled   = var.logging_to_kinesis_data_firehose.enabled
        id        = subscription.id
        arn       = subscription.arn
        log_group = subscription.destination_arn
      }
    ])
    s3 = one([
      for subscription in aws_vpclattice_access_log_subscription.s3 : {
        enabled   = var.logging_to_s3.enabled
        id        = subscription.id
        arn       = subscription.arn
        log_group = subscription.destination_arn
      }
    ])
  }
}

output "sharing" {
  description = <<EOF
  The configuration for sharing of the Lattice service network.
    `status` - An indication of whether the Lattice service network is shared with other AWS accounts, or was shared with the current account by another AWS account. Sharing is configured through AWS Resource Access Manager (AWS RAM). Values are `NOT_SHARED`, `SHARED_BY_ME` or `SHARED_WITH_ME`.
    `shares` - The list of resource shares via RAM (Resource Access Manager).
  EOF
  value = {
    status = length(module.share) > 0 ? "SHARED_BY_ME" : "NOT_SHARED"
    shares = module.share
  }
}
