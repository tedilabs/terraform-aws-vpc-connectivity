# lattice-service-listener

This module creates following resources.

- `aws_vpclattice_listener`
- `aws_vpclattice_listener_rule` (optional)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.17.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | tedilabs/misc/aws//modules/resource-group | ~> 0.10.0 |

## Resources

| Name | Type |
|------|------|
| [aws_vpclattice_listener.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpclattice_listener) | resource |
| [aws_vpclattice_listener_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpclattice_listener_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_action_type"></a> [default\_action\_type](#input\_default\_action\_type) | (Required) The type of default routing action. Default action apply to traffic that does not meet the conditions of rules on your listener. Rules can be configured after the listener is created. Valid values are `FORWARD`, `FIXED_RESPONSE`. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the service listener. The name must be unique within the service. The valid characters are a-z, 0-9, and hyphens (-). You can't use a hyphen as the first or last character, or immediately after another hyphen. | `string` | n/a | yes |
| <a name="input_protocol"></a> [protocol](#input\_protocol) | (Required) The protocol for the service listener. Valid values are `HTTP` and `HTTPS`. | `string` | n/a | yes |
| <a name="input_service"></a> [service](#input\_service) | (Required) The ID or ARN (Amazon Resource Name) of the VPC Lattice service. | `string` | n/a | yes |
| <a name="input_default_action_parameters"></a> [default\_action\_parameters](#input\_default\_action\_parameters) | (Optional) The configuration for the parameters of the default routing action. `default_action_parameters` block as defined below.<br>    (Optional) `status_code` - Custom HTTP status code to drop client requests and return a custom HTTP response. Valid values are `404`. Only supported if `default_action_type` is `FIXED_RESPONSE`.<br>    (Optional) `destinations` - A list of one or more target groups to route traffic. Only supported if `default_action_type` is `FORWARD`. Each item of `destinations` block as defined below.<br>      (Required) `target_group` - The ID or ARN of the target group to which to route traffic.<br>      (Optional) `weight` - The weight to use routing traffic to `target_group`. how requests are distributed to the target group. Only required if you specify multiple target groups for a forward action. For example, if you specify two target groups, one with a weight of 10 and the other with a weight of 20, the target group with a weight of 20 receives twice as many requests as the other target group. Valid value is `0` to `999`. Defaults to `100`. | <pre>object({<br>    status_code = optional(number, 404)<br>    destinations = optional(list(object({<br>      target_group = string<br>      weight       = optional(number, 100)<br>    })), [])<br>  })</pre> | `{}` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_port"></a> [port](#input\_port) | (Optional) The number of port on which the listener of the service is listening. Valid values are from `1` to `65535`. If `port` is not specified and `protocol` is `HTTP`, the value will default to `80`. If `port` is not specified and `protocol` is `HTTPS`, the value will default to `443`. | `number` | `null` | no |
| <a name="input_resource_group_description"></a> [resource\_group\_description](#input\_resource\_group\_description) | (Optional) The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_resource_group_enabled"></a> [resource\_group\_enabled](#input\_resource\_group\_enabled) | (Optional) Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| <a name="input_rules"></a> [rules](#input\_rules) | (Optional) The configuration for the parameters of the default routing action. `default_action_parameters` block as defined below.<br>    (Optional) `status_code` - The status code of HTTP response. Valid values are `2XX`, `4XX`, or `5XX`. Defaults to `503`. Only supported if `default_action_type` is `FIXED_RESPONSE`.<br>    (Required) `targets` - A list of target configurations to route traffic. To route to a single target group, use `default_action_type` as `FORWARD`. Only supported if `default_action_type` is `WEIGHTED_FORWARD`. Each item of `targets` block as defined below.<br>      (Required) `target_group` - The ARN of the target group to which to route traffic.<br>      (Optional) `weight` - The weight to use routing traffic to `target_group`. Valid value is `0` to `999`. Defaults to `1`. | <pre>list(object({<br>    priority = number<br>    name     = optional(string)<br><br>    action_type = string<br>    action_parameters = optional(object({<br>      status_code = optional(number, 404)<br>      destinations = optional(list(object({<br>        target_group = string<br>        weight       = optional(number, 100)<br>      })), [])<br>    }), {})<br>  }))</pre> | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the service listener. |
| <a name="output_created_at"></a> [created\_at](#output\_created\_at) | Date and time that the listener was created, specified in ISO-8601 format. |
| <a name="output_default_action"></a> [default\_action](#output\_default\_action) | The configuration for default routing action of the service listener.<br>    `type` - The type of default routing action.<br>    `parameters` - The configuration for the parameters of the default routing action. `default_action_parameters` block as defined below. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the service listener. |
| <a name="output_name"></a> [name](#output\_name) | The name of the service listener. |
| <a name="output_port"></a> [port](#output\_port) | The number of port on which the listener of the service is listening. |
| <a name="output_protocol"></a> [protocol](#output\_protocol) | The protocol for the service listener. |
| <a name="output_rules"></a> [rules](#output\_rules) | The configuration for default routing action of the service listener.<br>    `type` - The type of default routing action.<br>    `parameters` - The configuration for the parameters of the default routing action. `default_action_parameters` block as defined below. |
| <a name="output_service"></a> [service](#output\_service) | The associated VPC Lattice service. |
| <a name="output_updated_at"></a> [updated\_at](#output\_updated\_at) | Date and time that the listener was last updated, specified in ISO-8601 format. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
