terraform {
  required_version = ">= 1.12"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.12"
      configuration_aliases = [
        aws.accepter,
        aws.requester,
      ]
    }
  }
}
