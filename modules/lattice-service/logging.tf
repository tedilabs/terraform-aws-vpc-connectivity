###################################################
# Access Logs for Service
###################################################

resource "aws_vpclattice_access_log_subscription" "cloudwatch" {
  count = var.logging_to_cloudwatch.enabled ? 1 : 0

  resource_identifier = aws_vpclattice_service.this.id
  destination_arn     = var.logging_to_cloudwatch.log_group

  tags = merge(
    {
      "Name" = "${var.name}/cloudwatch"
    },
    local.module_tags,
    var.tags,
  )
}

resource "aws_vpclattice_access_log_subscription" "kinesis_data_firehose" {
  count = var.logging_to_kinesis_data_firehose.enabled ? 1 : 0

  resource_identifier = aws_vpclattice_service.this.id
  destination_arn     = var.logging_to_kinesis_data_firehose.delivery_stream

  tags = merge(
    {
      "Name" = "${var.name}/kinesis-data-firehose"
    },
    local.module_tags,
    var.tags,
  )
}

resource "aws_vpclattice_access_log_subscription" "s3" {
  count = var.logging_to_s3.enabled ? 1 : 0

  resource_identifier = aws_vpclattice_service.this.id
  destination_arn     = var.logging_to_s3.bucket

  tags = merge(
    {
      "Name" = "${var.name}/s3"
    },
    local.module_tags,
    var.tags,
  )
}
