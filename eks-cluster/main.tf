/**
 * # terraform-eks-lab/eks-cluster
 *
 * This repository contains Terraform code to create an EKS cluster with managed node groups.
 * It will also create a VPC with public and private subnets across multiple availability zones.
 *
 */

terraform {
  required_version = "~> 1.4.0"
  required_providers {
    aws        = "~> 4.67"
    kubernetes = "~> 2.0"
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

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

##### Data Sources
data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

##### Locals
locals {
  resource_prefix = var.project.name
  azs             = formatlist("${data.aws_region.current.name}%s", var.vpc.azs)
  cluster_name    = "${local.resource_prefix}-${var.eks.cluster_name}-eks"
}
