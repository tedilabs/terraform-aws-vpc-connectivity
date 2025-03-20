# lattice-lambda-target-group

This module creates following resources.

- `aws_vpclattice_target_group`
- `aws_vpclattice_target_group_attachment` (optional)

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
| [aws_vpclattice_target_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpclattice_target_group) | resource |
| [aws_vpclattice_target_group_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpclattice_target_group_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the target group. The name must be unique within the account. The valid characters are a-z, 0-9, and hyphens (-). You can't use a hyphen as the first or last character, or immediately after another hyphen. | `string` | n/a | yes |
| <a name="input_lambda_event_structure_version"></a> [lambda\_event\_structure\_version](#input\_lambda\_event\_structure\_version) | (Optional) The version of the event structure that the Lambda function receives. Valid values are `V1` are `V2`. Defaults to `V2`. | `string` | `"V2"` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_resource_group_description"></a> [resource\_group\_description](#input\_resource\_group\_description) | (Optional) The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_resource_group_enabled"></a> [resource\_group\_enabled](#input\_resource\_group\_enabled) | (Optional) Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_targets"></a> [targets](#input\_targets) | (Optional) A list of targets to add to the target group. Each value of `targets` block as defined below.<br>    (Required) `name` - The name of the target. This value is only used internally within Terraform code.<br>    (Required) `lambda_function` - The Amazon Resource Name (ARN) of the target Lambda function. If your ARN doesn't specify a version or alias, the latest version ($LATEST) is used by default. If the ARN specifies a version or alias, it appears as the last segment of the ARN separated by a colon. | <pre>list(object({<br>    name            = string<br>    lambda_function = string<br>  }))</pre> | `[]` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | (Optional) How long to wait for the target group to be created/deleted. | <pre>object({<br>    create = optional(string, "5m")<br>    delete = optional(string, "5m")<br>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the target group. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the target group. |
| <a name="output_lambda_event_structure_version"></a> [lambda\_event\_structure\_version](#output\_lambda\_event\_structure\_version) | The version of the event structure that the Lambda function receives. |
| <a name="output_name"></a> [name](#output\_name) | The name of the target group. |
| <a name="output_status"></a> [status](#output\_status) | The status of the target group. |
| <a name="output_targets"></a> [targets](#output\_targets) | The list of targets of the target group.<br>    `name` - The name of the target. This value is only used internally within Terraform code.<br>    `lambda_function` - The Amazon Resource Name (ARN) of the target Lambda function. |
| <a name="output_type"></a> [type](#output\_type) | The type of target group. Always `LAMBDA`. |
<!-- END_TF_DOCS -->
