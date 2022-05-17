# ---------------------------------------------------------------------------------------------------------------------
# AWS PROVIDER FOR TF CLOUD
# ---------------------------------------------------------------------------------------------------------------------
terraform {
  required_version = "~>1.1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.8.0"
    }
  }
}

provider "aws" {
  version                 = "~> 4.8.0"
  region                  = var.aws_region
  profile                 = var.aws_profile
  shared_credentials_file = var.aws_shared_credentials_file
}

