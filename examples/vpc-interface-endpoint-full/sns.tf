###################################################
# SNS Topic
###################################################

module "topic" {
  source  = "tedilabs/messaging/aws//modules/sns-standard-topic"
  version = "~> 0.1.0"

  name         = "interface-aws-s3"
  display_name = "Interface Endpoint Events"

  subscriptions_by_email = [
    {
      email = "admin@example.com"
    },
  ]

  tags = {
    "project" = "terraform-aws-vpc-connectivity-examples"
  }
}
