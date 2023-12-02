# vpc-peering-accepter

This module creates following resources.

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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.22.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | tedilabs/misc/aws//modules/resource-group | ~> 0.10.0 |

## Resources

| Name | Type |
|------|------|
| [aws_vpc_peering_connection_accepter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |
| [aws_vpc_peering_connection_options.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |
| [aws_vpc_peering_connection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_peering_connection) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | (Required) Desired name for the VPC Peering resources. | `string` | n/a | yes |
| <a name="input_peering_connection"></a> [peering\_connection](#input\_peering\_connection) | (Required) The information of the VPC Peering Connection to accept. The given filters must match exactly one VPC peering connection. `peering_connection` as defined below.<br>    (Optional) `id` - The VPC Peering Connection ID to manage.<br>  account. | <pre>object({<br>    id = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_allow_remote_vpc_dns_resolution"></a> [allow\_remote\_vpc\_dns\_resolution](#input\_allow\_remote\_vpc\_dns\_resolution) | (Optional) Whether to allow a accepter VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the requester VPC. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_resource_group_description"></a> [resource\_group\_description](#input\_resource\_group\_description) | (Optional) The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_resource_group_enabled"></a> [resource\_group\_enabled](#input\_resource\_group\_enabled) | (Optional) Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_accepter_vpc"></a> [accepter\_vpc](#output\_accepter\_vpc) | The accepter information including AWS Account ID, Region, VPC ID. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the VPC Peering Connection. |
| <a name="output_name"></a> [name](#output\_name) | The VPC Peering name. |
| <a name="output_requester_vpc"></a> [requester\_vpc](#output\_requester\_vpc) | The requester information including AWS Account ID, Region, VPC ID. |
| <a name="output_status"></a> [status](#output\_status) | The status of the VPC Peering Connection request. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
