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
# Interface Endpoint
###################################################

module "endpoint" {
  source = "../../modules/vpc-interface-endpoint"
  # source  = "tedilabs/vpc-connectivity/aws//modules/vpc-interface-endpoint"
  # version = "~> 0.2.0"

  name         = "interface-aws-s3"
  service_name = "com.amazonaws.us-east-1.s3"
  auto_accept  = true

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "Allow-callers-from-specific-account",
        "Effect": "Allow",
        "Principal": "*",
        "Action": "*",
        "Resource": "*",
        "Condition": {
          "StringEquals": {
            "aws:PrincipalAccount": "111122223333"
          }
        }
      }
    ]
  }
  EOF

  ## Network
  vpc_id          = data.aws_vpc.default.id
  ip_address_type = "IPv4"
  network_mapping = {
    "use1-az1" = {
      subnet = data.aws_subnet.default["use1-az1"].id
    }
    "use1-az2" = {
      subnet = data.aws_subnet.default["use1-az2"].id
    }
  }
  default_security_group = {
    enabled     = true
    name        = "interface-aws-s3"
    description = "Managed by Terraform."
    ingress_rules = [
      {
        id          = "tcp/all"
        description = "Allow all tcp traffic by default."
        protocol    = "tcp"
        from_port   = 0
        to_port     = 0
        ipv4_cidrs  = ["0.0.0.0/0"]
      },
    ]
  }
  security_groups = []


  ## DNS
  private_dns = {
    enabled                            = true
    record_ip_type                     = "IPv4"
    only_for_inbound_resolver_endpoint = false
  }


  ## Notifications
  connection_notifications = [
    {
      name      = "admin-email"
      sns_topic = module.topic.arn
      events    = ["Accept", "Reject"]
    }
  ]


  tags = {
    "project" = "terraform-aws-vpc-connectivity-examples"
  }
}
