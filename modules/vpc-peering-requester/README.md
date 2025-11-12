# vpc-peering-requester

This module creates following resources.

- `aws_vpc_peering_connection`
- `aws_vpc_peering_connection_options` (optional)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.20.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | tedilabs/misc/aws//modules/resource-group | ~> 0.12.0 |

## Resources

| Name | Type |
|------|------|
| [aws_vpc_peering_connection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) | resource |
| [aws_vpc_peering_connection_options.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_vpc_peering_connection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_peering_connection) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accepter"></a> [accepter](#input\_accepter) | (Required) The configuration of the accepter VPC. `accepter` as defined below.<br/>    (Required) `vpc` - The ID of the VPC with which you are creating the VPC Peering Connection.<br/>    (Optional) `region` - The region of the VPC with which you are creating the VPC Peering Connection. Defaults to the region of the current provider.<br/>    (Optional) `account` - The AWS account ID of the owner of the peer VPC. Defaults to the current<br/>  account. | <pre>object({<br/>    vpc     = string<br/>    region  = optional(string)<br/>    account = optional(string)<br/>  })</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) Desired name for the VPC Peering resources. | `string` | n/a | yes |
| <a name="input_requester"></a> [requester](#input\_requester) | (Required) The configuration of the requester VPC. `requester` as defined below.<br/>    (Required) `vpc` - The ID of the requester VPC.<br/>  account. | <pre>object({<br/>    vpc = string<br/>  })</pre> | n/a | yes |
| <a name="input_allow_remote_vpc_dns_resolution"></a> [allow\_remote\_vpc\_dns\_resolution](#input\_allow\_remote\_vpc\_dns\_resolution) | (Optional) Whether to allow a requester VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the accepter VPC. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_region"></a> [region](#input\_region) | (Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region. | `string` | `null` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Optional) A configurations of Resource Group for this module. `resource_group` as defined below.<br/>    (Optional) `enabled` - Whether to create Resource Group to find and group AWS resources which are created by this module. Defaults to `true`.<br/>    (Optional) `name` - The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. If not provided, a name will be generated using the module name and instance name.<br/>    (Optional) `description` - The description of Resource Group. Defaults to `Managed by Terraform.`. | <pre>object({<br/>    enabled     = optional(bool, true)<br/>    name        = optional(string, "")<br/>    description = optional(string, "Managed by Terraform.")<br/>  })</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_accepter"></a> [accepter](#output\_accepter) | The accepter information including AWS Account ID, Region, VPC ID. |
| <a name="output_allow_remote_vpc_dns_resolution"></a> [allow\_remote\_vpc\_dns\_resolution](#output\_allow\_remote\_vpc\_dns\_resolution) | Whether to allow a requester VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the accepter VPC. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the VPC Peering Connection. |
| <a name="output_name"></a> [name](#output\_name) | The VPC Peering name. |
| <a name="output_region"></a> [region](#output\_region) | The AWS region this module resources resides in. |
| <a name="output_requester"></a> [requester](#output\_requester) | The requester information including AWS Account ID, Region, VPC ID. |
| <a name="output_resource_group"></a> [resource\_group](#output\_resource\_group) | The resource group created to manage resources in this module. |
| <a name="output_status"></a> [status](#output\_status) | The status of the VPC Peering Connection request. |
<!-- END_TF_DOCS -->
