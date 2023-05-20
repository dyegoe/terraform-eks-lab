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

data "aws_region" "current" {}

locals {
  resource_prefix = var.project.name
  azs             = formatlist("${data.aws_region.current.name}%s", var.vpc.azs)

  eks_managed_node_groups = {
    for node in var.eks_managed_node_groups.nodes : node.name => {
      name         = "${local.resource_prefix}-${node.name}"
      min_size     = try(node.min_size, 1)
      max_size     = try(node.max_size, 3)
      desired_size = try(node.desired_size, 1)

      instance_types = try(node.instance_types, var.eks_managed_node_groups.defaults.instance_types)
      capacity_type  = try(node.capacity_type, "ON_DEMAND")

      tags = try(node.tags, {})
    }
  }
}
