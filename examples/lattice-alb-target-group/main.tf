provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "default" {
  for_each = toset(["use1-az1", "use1-az2"])

  availability_zone_id = each.key
  default_for_az       = true
}


###################################################
# ALB Target Group
###################################################

module "target_group" {
  source = "../../modules/lattice-alb-target-group"
  # source  = "tedilabs/vpc-connectivity/aws//modules/lattice-alb-target-group"
  # version = "~> 0.2.0"

  name = "alb-hello"

  vpc = data.aws_vpc.default.id

  port             = 80
  protocol         = "HTTP"
  protocol_version = "HTTP1"


  ## Targets
  targets = [
    {
      name = "alb-for-vpc-lattice"
      alb  = module.alb.arn
      port = 80
    }
  ]


  tags = {
    "project" = "terraform-aws-vpc-connectivity-examples"
  }
}
