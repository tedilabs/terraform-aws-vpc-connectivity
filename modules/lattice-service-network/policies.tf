###################################################
# Resource Policy of Service Network
###################################################

resource "aws_vpclattice_resource_policy" "this" {
  count = var.policy != null ? 1 : 0

  resource_arn = aws_vpclattice_service_network.this.arn
  policy       = var.policy
}


###################################################
# Auth Policy of Service Network
###################################################

resource "aws_vpclattice_auth_policy" "this" {
  count = var.auth_policy != null ? 1 : 0

  resource_identifier = aws_vpclattice_service_network.this.arn
  policy              = var.auth_policy
}
