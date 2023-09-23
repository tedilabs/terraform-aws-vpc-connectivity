###################################################
# Lambda Function
###################################################

module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 6.0.0"

  publish = true

  function_name = "lambda-function-for-vpc-lattice"
  source_path   = "${path.root}/function/"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  tags = {
    "project" = "terraform-aws-vpc-connectivity-examples"
  }
}
