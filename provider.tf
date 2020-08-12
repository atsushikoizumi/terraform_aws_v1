# Terraform version
terraform {
  # https://www.terraform.io/docs/backends/types/s3.html
  backend "s3" {
    bucket                  = "aws-aqua-terraform"
    key                     = "koizumi/develop_1.tfstate"
    region                  = "eu-west-1"
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "koizumi"
  }
  required_version = "= 0.12.28"
}

# Provider
# https://www.terraform.io/docs/providers/index.html
# https://github.com/terraform-aws-modules
provider "aws" {
  version                 = "3.0.0"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "koizumi"
  region                  = var.aws_region
}