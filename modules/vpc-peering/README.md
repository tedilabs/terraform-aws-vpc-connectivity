# vpc-peering

This module creates following resources.

- `aws_vpc_peering_connection`
- `aws_vpc_peering_connection_accepter`
- `aws_vpc_peering_connection_options`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.29 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.accepter"></a> [aws.accepter](#provider\_aws.accepter) | 5.29.0 |
| <a name="provider_aws.requester"></a> [aws.requester](#provider\_aws.requester) | 5.29.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_group_accepter"></a> [resource\_group\_accepter](#module\_resource\_group\_accepter) | tedilabs/misc/aws//modules/resource-group | ~> 0.10.0 |
| <a name="module_resource_group_requester"></a> [resource\_group\_requester](#module\_resource\_group\_requester) | tedilabs/misc/aws//modules/resource-group | ~> 0.10.0 |

## Resources

| Name | Type |
|------|------|
| [aws_vpc_peering_connection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) | resource |
| [aws_vpc_peering_connection_accepter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |
| [aws_vpc_peering_connection_options.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |
| [aws_vpc_peering_connection_options.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |
| [aws_caller_identity.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_caller_identity.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_region.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_vpc_peering_connection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_peering_connection) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accepter_vpc"></a> [accepter\_vpc](#input\_accepter\_vpc) | (Required) The configuration of the accepter VPC. `accepter_vpc` as defined below.<br>    (Required) `id` - The ID of the VPC with which you are creating the VPC Peering Connection.<br>  account. | <pre>object({<br>    id = string<br>  })</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) Desired name for the VPC Peering resources. | `string` | n/a | yes |
| <a name="input_requester_vpc"></a> [requester\_vpc](#input\_requester\_vpc) | (Required) The configuration of the requester VPC. `requester_vpc` as defined below.<br>    (Required) `id` - The ID of the requester VPC.<br>  account. | <pre>object({<br>    id = string<br>  })</pre> | n/a | yes |
| <a name="input_accepter_options"></a> [accepter\_options](#input\_accepter\_options) | (Optional) The accepter options of the VPC Peering Connection. `accepter_options` as defined below.<br>    (Optional) `allow_remote_vpc_dns_resolution` - Whether to allow a accepter VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the requester VPC. Defaults to `false`.<br>  account. | <pre>object({<br>    allow_remote_vpc_dns_resolution = optional(bool, false)<br>  })</pre> | `{}` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_requester_options"></a> [requester\_options](#input\_requester\_options) | (Optional) The requester options of the VPC Peering Connection. `requester_options` as defined below.<br>    (Optional) `allow_remote_vpc_dns_resolution` - Whether to allow a requester VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the accepter VPC. Defaults to `false`.<br>  account. | <pre>object({<br>    allow_remote_vpc_dns_resolution = optional(bool, false)<br>  })</pre> | `{}` | no |
| <a name="input_resource_group_description"></a> [resource\_group\_description](#input\_resource\_group\_description) | (Optional) The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_resource_group_enabled"></a> [resource\_group\_enabled](#input\_resource\_group\_enabled) | (Optional) Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_accepter_options"></a> [accepter\_options](#output\_accepter\_options) | The accepter options of the VPC Peering Connection. |
| <a name="output_accepter_vpc"></a> [accepter\_vpc](#output\_accepter\_vpc) | The accepter information including AWS Account ID, Region, VPC ID. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the VPC Peering Connection. |
| <a name="output_name"></a> [name](#output\_name) | The VPC Peering name. |
| <a name="output_requester_options"></a> [requester\_options](#output\_requester\_options) | The requester options of the VPC Peering Connection. |
| <a name="output_requester_vpc"></a> [requester\_vpc](#output\_requester\_vpc) | The requester information including AWS Account ID, Region, VPC ID. |
| <a name="output_status"></a> [status](#output\_status) | The status of the VPC Peering Connection request. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
