/**
 * # terraform-eks-lab/terraform
 *
 * This repository will create a VPC with public and private subnets across multiple availability zones. It also creates a NAT gateway and an internet gateway for the public subnets. The private subnets have a route to the NAT gateway to allow internet access.
 */

terraform {
  required_version = "~> 1.4.0"
  required_providers {
    aws = "~> 4.67"
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  default_tags {
    tags = var.project.default_tags
  }
}

data "aws_region" "current" {}

locals {
  resource_prefix = var.project.name
  azs             = formatlist("${data.aws_region.current.name}%s", var.vpc.azs)
}
