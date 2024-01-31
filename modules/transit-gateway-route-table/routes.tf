###################################################
# Attachment Route Propagations
###################################################

resource "aws_ec2_transit_gateway_route_table_propagation" "this" {
  for_each = {
    for propagation in var.attachment_route_propagations :
    coalesce(propagation.id, propagation.attachment) => propagation
  }

  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this.id
  transit_gateway_attachment_id  = each.value.attachment
}


###################################################
# Prefix List Routes
###################################################

resource "aws_ec2_transit_gateway_prefix_list_reference" "this" {
  for_each = {
    for route in var.prefix_list_routes :
    coalesce(route.id, route.destination) => route
  }

  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this.id

  prefix_list_id = each.value.destination

  blackhole = each.value.target != null ? false : true
  transit_gateway_attachment_id = (each.value.target != null
    ? each.value.target
    : null
  )
}


###################################################
# Static Routes
###################################################

resource "aws_ec2_transit_gateway_route" "this" {
  for_each = {
    for route in var.static_routes :
    route.destination => route
  }

  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this.id

  destination_cidr_block = each.value.destination

  blackhole = each.value.target != null ? false : true
  transit_gateway_attachment_id = (each.value.target != null
    ? each.value.target
    : null
  )
}
