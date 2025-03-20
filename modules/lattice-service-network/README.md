# lattice-service-network

This module creates following resources.

- `aws_vpclattice_service_network`
- `aws_vpclattice_auth_policy` (optional)
- `aws_vpclattice_resource_policy` (optional)
- `aws_vpclattice_service_network_vpc_association` (optional)
- `aws_vpclattice_service_network_service_association` (optional)
- `aws_vpclattice_access_log_subscription` (optional)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.21 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.22.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | tedilabs/misc/aws//modules/resource-group | ~> 0.10.0 |
| <a name="module_share"></a> [share](#module\_share) | tedilabs/account/aws//modules/ram-share | ~> 0.27.0 |

## Resources

| Name | Type |
|------|------|
| [aws_vpclattice_access_log_subscription.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpclattice_access_log_subscription) | resource |
| [aws_vpclattice_access_log_subscription.kinesis_data_firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpclattice_access_log_subscription) | resource |
| [aws_vpclattice_access_log_subscription.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpclattice_access_log_subscription) | resource |
| [aws_vpclattice_auth_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpclattice_auth_policy) | resource |
| [aws_vpclattice_resource_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpclattice_resource_policy) | resource |
| [aws_vpclattice_service_network.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpclattice_service_network) | resource |
| [aws_vpclattice_service_network_service_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpclattice_service_network_service_association) | resource |
| [aws_vpclattice_service_network_vpc_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpclattice_service_network_vpc_association) | resource |
| [aws_vpclattice_service_network.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpclattice_service_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the service network. The name must be between 3 and 63 characters. You can use lowercase letters, numbers, and hyphens. The name must begin and end with a letter or number. Do not use consecutive hyphens. | `string` | n/a | yes |
| <a name="input_auth_policy"></a> [auth\_policy](#input\_auth\_policy) | (Optional) The auth policy. Authorization decisions are made based on this policy, the service-level policy (if present), and IAM permissions attached to the client identity (if referencing IAM identities in this policy). The policy string in JSON must not contain newlines or blank lines. | `string` | `null` | no |
| <a name="input_auth_type"></a> [auth\_type](#input\_auth\_type) | (Optional) The type of authentication and authorization that manages client access to the service network. Valid values are `AWS_IAM` or `NONE`. Defaults to `NONE`.<br>    `NONE` - The service network will not authenticate or authorize client access. If an auth policy is present, it is inactive. Resources within associated VPCs will have access to services in this network, unless service-level policies restrict access.<br>    `AWS_IAM` - Applies an IAM resource policy on the service network. This provides administrators the ability to enforce authentication and write fine-grained permissions for the services in the network. | `string` | `"NONE"` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) The description of the service network. This creates a tag with a key of `Description` and a value that you specify. | `string` | `"Managed by Terraform."` | no |
| <a name="input_logging_to_cloudwatch"></a> [logging\_to\_cloudwatch](#input\_logging\_to\_cloudwatch) | (Optional) The configuration to enable access logs to be sent to Amazon CloudWatch Log Group. The service network owner can use the access logs to audit the services in the network. The service network owner will only see access logs from clients and services that are associated with their service network. Access log entries represent traffic originated from VPCs associated with that network. `logging_to_cloudwatch` as defined below.<br>    (Optional) `enabled` - Whether to enable access logs to be sent to Amazon CloudWatch Log Group.<br>    (Optional) `log_group` - The ARN (Amazon Resource Name) of the CloudWatch Log Group. | <pre>object({<br>    enabled   = optional(bool, false)<br>    log_group = optional(string, "")<br>  })</pre> | `{}` | no |
| <a name="input_logging_to_kinesis_data_firehose"></a> [logging\_to\_kinesis\_data\_firehose](#input\_logging\_to\_kinesis\_data\_firehose) | (Optional) The configuration to enable access logs to be sent to Amazon Kinesis Data Firehose. The service network owner can use the access logs to audit the services in the network. The service network owner will only see access logs from clients and services that are associated with their service network. Access log entries represent traffic originated from VPCs associated with that network. `logging_to_kinesis_data_firehose` as defined below.<br>    (Optional) `enabled` - Whether to enable access logs to be sent to Amazon Kinesis Data<br>  Firehose.<br>    (Optional) `delivery_stream` - The ARN (Amazon Resource Name) of the Kinesis Data Firehose<br>  delivery stream. | <pre>object({<br>    enabled         = optional(bool, false)<br>    delivery_stream = optional(string, "")<br>  })</pre> | `{}` | no |
| <a name="input_logging_to_s3"></a> [logging\_to\_s3](#input\_logging\_to\_s3) | (Optional) The configuration to enable access logs to be sent to Amazon S3 Bucket. The service network owner can use the access logs to audit the services in the network. The service network owner will only see access logs from clients and services that are associated with their service network. Access log entries represent traffic originated from VPCs associated with that network. `logging_to_s3` as defined below.<br>    (Optional) `enabled` - Whether to enable access logs to be sent to Amazon S3 Bucket.<br>    (Optional) `bucket` - The ARN (Amazon Resource Name) of the S3 Bucket. | <pre>object({<br>    enabled = optional(bool, false)<br>    bucket  = optional(string, "")<br>  })</pre> | `{}` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | (Optional) A resource-based permission policy for the service network. The policy must contain the same actions and condition statements as the Amazon Web Services Resource Access Manager permission for sharing services and service networks. | `string` | `null` | no |
| <a name="input_resource_group_description"></a> [resource\_group\_description](#input\_resource\_group\_description) | (Optional) The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_resource_group_enabled"></a> [resource\_group\_enabled](#input\_resource\_group\_enabled) | (Optional) Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| <a name="input_service_associations"></a> [service\_associations](#input\_service\_associations) | (Optional) The configuration for the service associations with the service network. To facilitate network client access to your service, you will need to associate your service to the relevant service networks. Only service networks created in the same account, or that have been shared with you (by way of Resource Access Manager), are available for you to create associations with. Each block of `service_associations` as defined below.<br>    (Required) `name` - The name of the service association.<br>    (Required) `service` - The ID or ARN (Amazon Resource Name) of the service.<br>    (Optional) `tags` - A map of tags to add to the service association. | <pre>list(object({<br>    name    = string<br>    service = string<br>    tags    = optional(map(string), {})<br>  }))</pre> | `[]` | no |
| <a name="input_shares"></a> [shares](#input\_shares) | (Optional) A list of resource shares via RAM (Resource Access Manager). | <pre>list(object({<br>    name = optional(string)<br><br>    permissions = optional(set(string), ["AWSRAMPermissionVpcLatticeServiceNetworkReadWrite"])<br><br>    external_principals_allowed = optional(bool, false)<br>    principals                  = optional(set(string), [])<br><br>    tags = optional(map(string), {})<br>  }))</pre> | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_vpc_associations"></a> [vpc\_associations](#input\_vpc\_associations) | (Optional) The configuration for VPC associations with the service network. It enables all the resources within that VPC to be clients and communicate with other services in the service network. Each block of `vpc_associations` as defined below.<br>    (Required) `vpc` - The ID of the VPC.<br>    (Optional) `security_groups` - A list of the IDs of the security groups.<br>    (Optional) `tags` - A map of tags to add to the vpc association. | <pre>list(object({<br>    vpc             = string<br>    security_groups = optional(set(string), [])<br>    tags            = optional(map(string), {})<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the service network. |
| <a name="output_auth_type"></a> [auth\_type](#output\_auth\_type) | The type of authentication and authorization that manages client access to the service network. |
| <a name="output_created_at"></a> [created\_at](#output\_created\_at) | Date and time that the service network was created, specified in ISO-8601 format. |
| <a name="output_description"></a> [description](#output\_description) | The description of the service network. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the service network. |
| <a name="output_logging"></a> [logging](#output\_logging) | The configuration for access logs of the service network.<br>  Firehose Delivery Stream, Amazon S3 Bucket.<br>    `cloudwatch` - The configuration for access logs to be sent to Amazon CloudWatch Log Group.<br>    `kinesis_data_firehose` - The configuration for access logs to be sent to Amazon Kinesis Data<br>  Firehose Delivery Stream.<br>    `s3` - The configuration for access logs to be sent to Amazon S3 BUcket. |
| <a name="output_name"></a> [name](#output\_name) | The name of the service network. |
| <a name="output_service_associations"></a> [service\_associations](#output\_service\_associations) | The list of the service associations with the service network.<br>    `id` - The ID of the association.<br>    `arn` - The ARN of the Association.<br>    `status` - The operations status. Valid Values are `CREATE_IN_PROGRESS`, `ACTIVE`, `DELETE_IN_PROGRESS`, `CREATE_FAILED`, `DELETE_FAILED`.<br>    `created_by` - The principal that created the association.<br><br>    `service` - The ARN (Amazon Resource Name) of the service. |
| <a name="output_sharing"></a> [sharing](#output\_sharing) | The configuration for sharing of the Lattice service network.<br>    `status` - An indication of whether the Lattice service network is shared with other AWS accounts, or was shared with the current account by another AWS account. Sharing is configured through AWS Resource Access Manager (AWS RAM). Values are `NOT_SHARED`, `SHARED_BY_ME` or `SHARED_WITH_ME`.<br>    `shares` - The list of resource shares via RAM (Resource Access Manager). |
| <a name="output_updated_at"></a> [updated\_at](#output\_updated\_at) | Date and time that the service network was last updated, specified in ISO-8601 format. |
| <a name="output_vpc_associations"></a> [vpc\_associations](#output\_vpc\_associations) | The list of VPC associations with the service network.<br>    `id` - The ID of the association.<br>    `arn` - The ARN of the Association.<br>    `status` - The operations status. Valid Values are `CREATE_IN_PROGRESS`, `ACTIVE`, `DELETE_IN_PROGRESS`, `CREATE_FAILED`, `DELETE_FAILED`.<br>    `created_by` - The principal that created the association.<br><br>    `vpc` - The ID of the VPC.<br>    `security_groups` - A list of the IDs of the security groups. |
<!-- END_TF_DOCS -->
