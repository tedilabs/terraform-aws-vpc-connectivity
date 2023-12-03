terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.29"
      configuration_aliases = [
        aws.accepter,
        aws.requester,
      ]
    }
  }
}
