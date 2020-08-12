# VPC
# https://www.terraform.io/docs/providers/aws/r/vpc.html
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "false"

  tags = {
    Name  = "${var.tags_owner}-vpc"
    Owner = var.tags_owner
  }
}

# IGW
# https://www.terraform.io/docs/providers/aws/r/internet_gateway.html
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name  = "${var.tags_owner}-igw"
    Owner = var.tags_owner
  }
}