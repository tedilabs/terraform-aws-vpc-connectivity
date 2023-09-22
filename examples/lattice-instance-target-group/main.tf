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
# Instance Target Group
###################################################

module "target_group" {
  source = "../../modules/lattice-instance-target-group"
  # source  = "tedilabs/vpc-connectivity/aws//modules/lattice-instance-target-group"
  # version = "~> 0.2.0"

  name = "instance-hello"

  vpc = data.aws_vpc.default.id

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
    for instance in module.instance : {
      name     = instance.name
      instance = instance.id
      port     = 80
    }
  ]


  tags = {
    "project" = "terraform-aws-vpc-connectivity-examples"
  }
}


###################################################
# EC2 Instance
###################################################

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}


module "instance" {
  source  = "tedilabs/ec2/aws//modules/instance"
  version = "~> 0.2.0"

  count = 3

  name = "instance-${count.index}"
  type = "t2.micro"
  ami  = data.aws_ami.ubuntu.image_id

  tags = {
    "project" = "terraform-aws-vpc-connectivity-examples"
  }
}
