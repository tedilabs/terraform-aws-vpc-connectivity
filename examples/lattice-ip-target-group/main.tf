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
# IP Target Group
###################################################

module "target_group" {
  source = "../../modules/lattice-ip-target-group"
  # source  = "tedilabs/vpc-connectivity/aws//modules/lattice-ip-target-group"
  # version = "~> 0.2.0"

  name = "ip-hello"

  vpc = data.aws_vpc.default.id

  ip_address_type  = "IPV4"
  port             = 80
  protocol         = "HTTP"
  protocol_version = "HTTP1"


  ## Health Check
  health_check = {
    enabled = true

    port             = 80
    protocol         = "HTTP"
    protocol_version = "HTTP1"
    path             = "/"

    success_codes = "200-299"

    interval = 30
    timeout  = 5

    healthy_threshold   = 5
    unhealthy_threshold = 2
  }


  ## Targets
  targets = [
    {
      name       = "ip-1"
      ip_address = "172.31.10.111"
      port       = 80
    },
    {
      name       = "ip-2"
      ip_address = "172.31.10.112"
      port       = 80
    },
    {
      name       = "ip-3"
      ip_address = "172.31.10.113"
      port       = 80
    },
  ]


  tags = {
    "project" = "terraform-aws-vpc-connectivity-examples"
  }
}
