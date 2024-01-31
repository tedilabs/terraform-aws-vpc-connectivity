# transit-gateway-route-table

This module creates following resources.

- `aws_ec2_transit_gateway_route_table`
- `aws_ec2_transit_gateway_route_table_association` (optional)
- `aws_ec2_transit_gateway_route_table_propagation` (optional)
- `aws_ec2_transit_gateway_prefix_list_reference` (optional)
- `aws_ec2_transit_gateway_route` (optional)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.58 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.31.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | tedilabs/misc/aws//modules/resource-group | ~> 0.10.0 |
| <a name="module_share"></a> [share](#module\_share) | tedilabs/account/aws//modules/ram-share | ~> 0.24.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the Transit Gateway. | `string` | n/a | yes |
| <a name="input_asn"></a> [asn](#input\_asn) | (Optional) The ASN(Autonomous System Number) to be configured on the Amazon side of a BGP session. Modifying `asn` on a Transit Gateway with active BGP sessions is not allowed. The ASN must be in the private range of `64512` to `65534` or `4200000000` to `4294967294`. Defaults to `64512.` | `number` | `64512` | no |
| <a name="input_auto_accept_cross_account_attachments"></a> [auto\_accept\_cross\_account\_attachments](#input\_auto\_accept\_cross\_account\_attachments) | (Optional) Whether to automatically accept cross-account attachments that are attached to this transit gateway. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_cidr_blocks"></a> [cidr\_blocks](#input\_cidr\_blocks) | (Optional) A set of IPv4 or IPv6 CIDR blocks for the Transit Gateway. Must be a size /24 CIDR block or larger for IPv4, or a size /64 CIDR block or larger for IPv6. | `set(string)` | `[]` | no |
| <a name="input_default_association_route_table"></a> [default\_association\_route\_table](#input\_default\_association\_route\_table) | (Optional) The configuration for the default association route table for automatic association. `default_association_route_table` block as defined below.<br>    (Optional) `enabled` - Whether to automatically associate transit gateway attachments with this transit gateway's default route table. Defaults to `false`. | <pre>object({<br>    enabled = optional(bool, false)<br>  })</pre> | `{}` | no |
| <a name="input_default_propagation_route_table"></a> [default\_propagation\_route\_table](#input\_default\_propagation\_route\_table) | (Optional) The configuration for the default propagation route table for automatic propagation. `default_propagation_route_table` block as defined below.<br>    (Optional) `enabled` - Whether to automatically propagate transit gateway attachments with this transit gateway's default route table. Defaults to `false`. | <pre>object({<br>    enabled = optional(bool, false)<br>  })</pre> | `{}` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) A description for the Transit Gateway. | `string` | `"Managed by Terraform."` | no |
| <a name="input_dns_support_enabled"></a> [dns\_support\_enabled](#input\_dns\_support\_enabled) | (Optional) Whether to enable Domain Name System resolution for VPCs attached to this transit gateway. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_multicast_support_enabled"></a> [multicast\_support\_enabled](#input\_multicast\_support\_enabled) | (Optional) Whether to enable the ability to create multicast domains in this transit gateway. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_resource_group_description"></a> [resource\_group\_description](#input\_resource\_group\_description) | (Optional) The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_resource_group_enabled"></a> [resource\_group\_enabled](#input\_resource\_group\_enabled) | (Optional) Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| <a name="input_shares"></a> [shares](#input\_shares) | (Optional) A list of resource shares via RAM (Resource Access Manager). | <pre>list(object({<br>    name = optional(string)<br><br>    permissions = optional(set(string), ["AWSRAMDefaultPermissionTransitGateway"])<br><br>    external_principals_allowed = optional(bool, false)<br>    principals                  = optional(set(string), [])<br><br>    tags = optional(map(string), {})<br>  }))</pre> | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_vpn_ecmp_support_enabled"></a> [vpn\_ecmp\_support\_enabled](#input\_vpn\_ecmp\_support\_enabled) | (Optional) Whether to enable Equal cost multipath (ECMP) routing for VPN Connections that are attached to this transit gateway. Defaults to `true`. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN (Amazon Resource Name) of the Transit Gateway. |
| <a name="output_asn"></a> [asn](#output\_asn) | The ASN of the Amazon side of the Transit Gateway. |
| <a name="output_attributes"></a> [attributes](#output\_attributes) | Attributes that applied to the Transit Gateway. |
| <a name="output_cidr_blocks"></a> [cidr\_blocks](#output\_cidr\_blocks) | The set of IPv4 or IPv6 CIDR blocks for the Transit Gateway. |
| <a name="output_default_association_route_table"></a> [default\_association\_route\_table](#output\_default\_association\_route\_table) | The configuration for the default association route table for automatic association.<br>    `enabled` - Whether to automatically associate transit gateway attachments with this transit gateway's default route table.<br>    `route_table` - The ID of the default association route table. |
| <a name="output_default_propagation_route_table"></a> [default\_propagation\_route\_table](#output\_default\_propagation\_route\_table) | The configuration for the default propagation route table for automatic propagation.<br>    `enabled` - Whether to automatically propagate transit gateway attachments with this transit gateway's default route table.<br>    `route_table` - The ID of the default propagation route table. |
| <a name="output_description"></a> [description](#output\_description) | The description of the Transit Gateway. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the Transit Gateway. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Transit Gateway. |
| <a name="output_owner_id"></a> [owner\_id](#output\_owner\_id) | ID of the AWS account that owns the Transit Gateway. |
| <a name="output_sharing"></a> [sharing](#output\_sharing) | The configuration for sharing of the Transit Gateway.<br>    `status` - An indication of whether the Transit Gateway is shared with other AWS accounts, or was shared with the current account by another AWS account. Sharing is configured through AWS Resource Access Manager (AWS RAM). Values are `NOT_SHARED`, `SHARED_BY_ME` or `SHARED_WITH_ME`.<br>    `shares` - The list of resource shares via RAM (Resource Access Manager). |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
