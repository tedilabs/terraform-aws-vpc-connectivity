provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_route_tables" "this" {
  vpc_id = data.aws_vpc.default.id
}


###################################################
# Gateway Endpoint
###################################################

module "endpoint" {
  source = "../../modules/vpc-gateway-endpoint"
  # source  = "tedilabs/vpc-connectivity/aws//modules/vpc-gateway-endpoint"
  # version = "~> 0.2.0"

  vpc_id = data.aws_vpc.default.id

  name    = "aws-s3"
  service = "S3"

  route_tables = data.aws_route_tables.this.ids


  tags = {
    "project" = "terraform-aws-vpc-connectivity-examples"
  }
}
