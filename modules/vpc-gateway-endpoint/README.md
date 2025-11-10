# vpc-gateway-endpoint

This module creates following resources.

- `aws_vpc_endpoint`
- `aws_vpc_endpoint_policy`
- `aws_vpc_endpoint_route_table_association` (optional)

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
| [aws_vpc_endpoint.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_policy) | resource |
| [aws_vpc_endpoint_route_table_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_route_table_association) | resource |
| [aws_vpc_endpoint_service.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint_service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | (Required) Desired name for the VPC Gateway Endpoint. | `string` | n/a | yes |
| <a name="input_service"></a> [service](#input\_service) | (Required) The AWS service name. Valid values are `DYNAMODB`, `S3`, `S3EXPRESS`. | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | (Required) The ID of the VPC in which the endpoint will be used. | `string` | n/a | yes |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | (Optional) A policy to attach to the endpoint that controls access to the service. This is a JSON formatted string. Defaults to full access. All Gateway endpoints support policies. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | (Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region. | `string` | `null` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Optional) A configurations of Resource Group for this module. `resource_group` as defined below.<br/>    (Optional) `enabled` - Whether to create Resource Group to find and group AWS resources which are created by this module. Defaults to `true`.<br/>    (Optional) `name` - The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. If not provided, a name will be generated using the module name and instance name.<br/>    (Optional) `description` - The description of Resource Group. Defaults to `Managed by Terraform.`. | <pre>object({<br/>    enabled     = optional(bool, true)<br/>    name        = optional(string, "")<br/>    description = optional(string, "Managed by Terraform.")<br/>  })</pre> | `{}` | no |
| <a name="input_route_tables"></a> [route\_tables](#input\_route\_tables) | (Optional) A list of route table IDs to associate with the endpoint. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | (Optional) How long to wait for the endpoint to be created/updated/deleted. | <pre>object({<br/>    create = optional(string, "10m")<br/>    update = optional(string, "10m")<br/>    delete = optional(string, "10m")<br/>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The Amazon Resource Name (ARN) of the VPC endpoint. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the VPC endpoint. |
| <a name="output_name"></a> [name](#output\_name) | The VPC Gateway Endpoint name. |
| <a name="output_owner_id"></a> [owner\_id](#output\_owner\_id) | The owner ID of the VPC endpoint. |
| <a name="output_prefix_list"></a> [prefix\_list](#output\_prefix\_list) | The information of the prefix list of the VPC endpoint.<br/>    `id` - The prefix list ID of the exposed AWS service.<br/>    `ipv4_cidrs` - The list of CIDR blocks for the exposed AWS service. |
| <a name="output_region"></a> [region](#output\_region) | The AWS region this module resources resides in. |
| <a name="output_resource_group"></a> [resource\_group](#output\_resource\_group) | The resource group created to manage resources in this module. |
| <a name="output_route_tables"></a> [route\_tables](#output\_route\_tables) | The list of route table IDs which is associated with the VPC endpoint. |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | The service name of the VPC Gateway Endpoint. |
| <a name="output_state"></a> [state](#output\_state) | The state of the VPC endpoint. |
| <a name="output_type"></a> [type](#output\_type) | The type of the VPC endpoint. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The VPC ID of the VPC endpoint. |
<!-- END_TF_DOCS -->
