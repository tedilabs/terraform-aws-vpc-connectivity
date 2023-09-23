provider "aws" {
  region = "us-east-1"
}


###################################################
# Lambda Target Group
###################################################

module "target_group" {
  source = "../../modules/lattice-lambda-target-group"
  # source  = "tedilabs/vpc-connectivity/aws//modules/lattice-lambda-target-group"
  # version = "~> 0.2.0"

  name = "lambda-hello"


  ## Targets
  targets = [
    {
      name            = "lambda-function-for-vpc-lattice"
      lambda_function = module.lambda_function.lambda_function_arn
    }
  ]


  tags = {
    "project" = "terraform-aws-vpc-connectivity-examples"
  }
}
