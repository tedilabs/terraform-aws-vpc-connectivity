provider "aws" {
  region = "us-east-1"
}


###################################################
# Service Network of VPC Lattice
###################################################

module "service_network" {
  source = "../../modules/lattice-service-network"
  # source  = "tedilabs/vpc-connectivity/aws//modules/lattice-service-network"
  # version = "~> 0.2.0"

  name      = "test"
  auth_type = "NONE"

  tags = {
    "project" = "terraform-aws-vpc-connectivity-examples"
  }
}
