terraform {
  required_version = ">= 1.12"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.63"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.4"
    }
    telemetry = {
      source  = "tedilabs/telemetry"
      version = ">= 0.2.0"
    }
  }
}
