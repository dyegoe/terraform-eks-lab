/**
 * # terraform-eks-lab/terraform
 *
 * This repository contains Terraform code to create an EKS cluster with managed node groups.
 * It will also create a VPC with public and private subnets across multiple availability zones.
 *
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
    tags = merge(
      var.project.default_tags,
      { Project = var.project.name }
    )
  }
}
