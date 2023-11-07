provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
}


###################################################
# Interface Endpoint
###################################################

module "endpoint" {
  source = "../../modules/vpc-interface-endpoint"
  # source  = "tedilabs/vpc-connectivity/aws//modules/vpc-interface-endpoint"
  # version = "~> 0.2.0"

  name         = "interface-aws-s3"
  service_name = "com.amazonaws.us-east-1.s3"


  ## Network
  vpc_id = data.aws_vpc.default.id


  tags = {
    "project" = "terraform-aws-vpc-connectivity-examples"
  }
}
