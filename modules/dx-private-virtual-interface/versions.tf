terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.63"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.4"
    }
  }
}
