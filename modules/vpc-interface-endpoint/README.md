# vpc-interface-endpoint

This module creates following resources.

- `aws_vpc_endpoint`
- `aws_vpc_endpoint_policy`
- `aws_vpc_endpoint_security_group_association`
- `aws_vpc_endpoint_subnet_association` (optional)
- `aws_vpc_endpoint_connection_notification` (optional)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.20 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.24.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | tedilabs/misc/aws//modules/resource-group | ~> 0.10.0 |
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | tedilabs/network/aws//modules/security-group | ~> 0.29.0 |

## Resources

| Name | Type |
|------|------|
| [aws_vpc_endpoint.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint_connection_notification.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_connection_notification) | resource |
| [aws_vpc_endpoint_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_policy) | resource |
| [aws_vpc_endpoint_security_group_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_security_group_association) | resource |
| [aws_vpc_endpoint_subnet_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_subnet_association) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | (Required) Desired name for the VPC Interface Endpoint. | `string` | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | (Required) The service name. For AWS services the service name is usually in the form `com.amazonaws.<region>.<service>`. | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | (Required) The ID of the VPC in which the endpoint will be used. | `string` | n/a | yes |
| <a name="input_auto_accept"></a> [auto\_accept](#input\_auto\_accept) | (Optional) Accept the VPC endpoint (the VPC endpoint and service need to be in the same AWS account). | `bool` | `true` | no |
| <a name="input_connection_notifications"></a> [connection\_notifications](#input\_connection\_notifications) | (Optional) A list of configurations of Endpoint Connection Notifications for VPC Endpoint events. Each block of `connection_notifications` as defined below.<br>    (Required) `name` - The name of the configuration for connection notification. This value is only used internally within Terraform code.<br>    (Required) `sns_topic` - The Amazon Resource Name (ARN) of the SNS topic for the notifications.<br>    (Required) `events` - One or more endpoint events for which to receive notifications. Valid values are `Accept`, `Reject`, `Connect` and `Delete`. | <pre>list(object({<br>    name      = string<br>    sns_topic = string<br>    events    = set(string)<br>  }))</pre> | `[]` | no |
| <a name="input_default_security_group"></a> [default\_security\_group](#input\_default\_security\_group) | (Optional) The configuration of the default security group for the interface endpoint. `default_security_group` block as defined below.<br>    (Optional) `enabled` - Whether to use the default security group. Defaults to `true`.<br>    (Optional) `name` - The name of the default security group. If not provided, the endpoint name is used for the name of security group.<br>    (Optional) `description` - The description of the default security group.<br>    (Optional) `ingress_rules` - A list of ingress rules in a security group. You don't need to specify `protocol`, `from_port`, `to_port`. Just specify source information. Defaults to `[{ cidr_blocks = "0.0.0.0/0" }]`. | <pre>object({<br>    enabled     = optional(bool, true)<br>    name        = optional(string)<br>    description = optional(string, "Managed by Terraform.")<br>    ingress_rules = optional(any, [{<br>      cidr_blocks = ["0.0.0.0/0"]<br>    }])<br>  })</pre> | `{}` | no |
| <a name="input_ip_address_type"></a> [ip\_address\_type](#input\_ip\_address\_type) | (Optional) The type of IP addresses used by the subnets for the interface endpoint. The possible values are `IPV4`, `IPV6` and `DUALSTACK`. Defaults to `IPV4` | `string` | `"IPV4"` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_network_mapping"></a> [network\_mapping](#input\_network\_mapping) | (Optional) The configuration for the interface endpoint how routes traffic to targets in which subnets, and in accordance with IP address settings. Choose one subnet for each zone. An endpoint network interface is assigned a private IP address from the IP address range of your subnet, and keeps this IP address until the interface endpoint is deleted. Each key of `network_mapping` is the availability zone id like `apne2-az1`, `use1-az1`. Each block of `network_mapping` as defined below.<br>    (Required) `subnet` - The id of the subnet of which to attach to the endpoint. You can specify only one subnet per Availability Zone. | <pre>map(object({<br>    subnet = string<br>  }))</pre> | `{}` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | (Optional) A policy to attach to the endpoint that controls access to the service. This is a JSON formatted string. Defaults to full access. All Gateway and some Interface endpoints support policies. | `string` | `null` | no |
| <a name="input_private_dns_enabled"></a> [private\_dns\_enabled](#input\_private\_dns\_enabled) | (Optional) Whether or not to associate a private hosted zone with the specified VPC. | `bool` | `false` | no |
| <a name="input_resource_group_description"></a> [resource\_group\_description](#input\_resource\_group\_description) | (Optional) The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_resource_group_enabled"></a> [resource\_group\_enabled](#input\_resource\_group\_enabled) | (Optional) Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | (Optional) A list of security group IDs to associate with the endpoint. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | (Optional) How long to wait for the endpoint to be created/updated/deleted. | <pre>object({<br>    create = optional(string, "10m")<br>    update = optional(string, "10m")<br>    delete = optional(string, "10m")<br>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The Amazon Resource Name (ARN) of the VPC endpoint. |
| <a name="output_connection_notifications"></a> [connection\_notifications](#output\_connection\_notifications) | A list of Endpoint Connection Notifications for VPC Endpoint events. |
| <a name="output_default_security_group"></a> [default\_security\_group](#output\_default\_security\_group) | The default security group ID of the VPC endpoint. |
| <a name="output_dns_entries"></a> [dns\_entries](#output\_dns\_entries) | The DNS entries for the VPC Endpoint. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the VPC endpoint. |
| <a name="output_ip_address_type"></a> [ip\_address\_type](#output\_ip\_address\_type) | The type of IP addresses used by the VPC endpoint. |
| <a name="output_name"></a> [name](#output\_name) | The VPC Interface Endpoint name. |
| <a name="output_network_interfaces"></a> [network\_interfaces](#output\_network\_interfaces) | One or more network interfaces for the VPC Endpoint. |
| <a name="output_network_mapping"></a> [network\_mapping](#output\_network\_mapping) | The configuration for the endpoint how routes traffic to targets in which subnets and IP address settings. |
| <a name="output_owner_id"></a> [owner\_id](#output\_owner\_id) | The Owner ID of the VPC endpoint. |
| <a name="output_requester_managed"></a> [requester\_managed](#output\_requester\_managed) | Whether or not the VPC Endpoint is being managed by its service. |
| <a name="output_security_groups"></a> [security\_groups](#output\_security\_groups) | A set of security group IDs which is assigned to the VPC endpoint. |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | The service name of the VPC Interface Endpoint. |
| <a name="output_state"></a> [state](#output\_state) | The state of the VPC endpoint. |
| <a name="output_type"></a> [type](#output\_type) | The type of the VPC endpoint. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The VPC ID of the VPC endpoint. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
