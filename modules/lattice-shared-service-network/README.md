# lattice-shared-service-network

This module creates following resources.

- `aws_vpclattice_service_network_vpc_association` (optional)
- `aws_vpclattice_service_network_service_association` (optional)

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

## Resources

| Name | Type |
|------|------|
| [aws_vpclattice_service_network_service_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpclattice_service_network_service_association) | resource |
| [aws_vpclattice_service_network_vpc_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpclattice_service_network_vpc_association) | resource |
| [aws_vpclattice_service_network.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpclattice_service_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_id"></a> [id](#input\_id) | (Required) The ID of the service network. | `string` | n/a | yes |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_resource_group_description"></a> [resource\_group\_description](#input\_resource\_group\_description) | (Optional) The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_resource_group_enabled"></a> [resource\_group\_enabled](#input\_resource\_group\_enabled) | (Optional) Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| <a name="input_service_associations"></a> [service\_associations](#input\_service\_associations) | (Optional) The configuration for the service associations with the service network. To facilitate network client access to your service, you will need to associate your service to the relevant service networks. Only service networks created in the same account, or that have been shared with you (by way of Resource Access Manager), are available for you to create associations with. Each block of `service_associations` as defined below.<br>    (Required) `name` - The name of the service association.<br>    (Required) `service` - The ID or ARN (Amazon Resource Name) of the service.<br>    (Optional) `tags` - A map of tags to add to the service association. | <pre>list(object({<br>    name    = string<br>    service = string<br>    tags    = optional(map(string), {})<br>  }))</pre> | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_vpc_associations"></a> [vpc\_associations](#input\_vpc\_associations) | (Optional) The configuration for VPC associations with the service network. It enables all the resources within that VPC to be clients and communicate with other services in the service network. Each block of `vpc_associations` as defined below.<br>    (Required) `vpc` - The ID of the VPC.<br>    (Optional) `security_groups` - A list of the IDs of the security groups.<br>    (Optional) `tags` - A map of tags to add to the vpc association. | <pre>list(object({<br>    vpc             = string<br>    security_groups = optional(set(string), [])<br>    tags            = optional(map(string), {})<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the service network. |
| <a name="output_auth_type"></a> [auth\_type](#output\_auth\_type) | The type of authentication and authorization that manages client access to the service network. |
| <a name="output_created_at"></a> [created\_at](#output\_created\_at) | Date and time that the service network was created, specified in ISO-8601 format. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the service network. |
| <a name="output_name"></a> [name](#output\_name) | The name of the service network. |
| <a name="output_service_associations"></a> [service\_associations](#output\_service\_associations) | The list of the service associations with the service network.<br>    `id` - The ID of the association.<br>    `arn` - The ARN of the Association.<br>    `status` - The operations status. Valid Values are `CREATE_IN_PROGRESS`, `ACTIVE`, `DELETE_IN_PROGRESS`, `CREATE_FAILED`, `DELETE_FAILED`.<br>    `created_by` - The principal that created the association.<br><br>    `service` - The ARN (Amazon Resource Name) of the service. |
| <a name="output_updated_at"></a> [updated\_at](#output\_updated\_at) | Date and time that the service network was last updated, specified in ISO-8601 format. |
| <a name="output_vpc_associations"></a> [vpc\_associations](#output\_vpc\_associations) | The list of VPC associations with the service network.<br>    `id` - The ID of the association.<br>    `arn` - The ARN of the Association.<br>    `status` - The operations status. Valid Values are `CREATE_IN_PROGRESS`, `ACTIVE`, `DELETE_IN_PROGRESS`, `CREATE_FAILED`, `DELETE_FAILED`.<br>    `created_by` - The principal that created the association.<br><br>    `vpc` - The ID of the VPC.<br>    `security_groups` - A list of the IDs of the security groups. |
<!-- END_TF_DOCS -->
