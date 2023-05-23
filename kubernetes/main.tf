/**
* # terraform-eks-lab/kubernetes
*
* This module is used to deploy Kubernetes resources to an EKS cluster.
**/

terraform {
  backend "s3" {
    bucket = "dyego-terraform"
    key    = "terraform-eks-lab/kubernetes/terraform.tfstate"
    region = "us-east-1"
  }

  required_version = "~> 1.4.0"
  required_providers {
    aws  = "~> 4.67"
    helm = "~> 2.9"
  }
}

provider "aws" {
  region  = local.aws_region
  profile = local.aws_profile

  default_tags {
    tags = merge(
      local.project.default_tags,
      { Project = local.project.name }
    )
  }
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

##### Data Sources
data "terraform_remote_state" "eks_cluster" {
  backend = "s3"

  config = {
    bucket = "dyego-terraform"
    key    = "terraform-eks-lab/eks-cluster/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_eks_cluster" "this" { name = local.cluster_name }

data "aws_eks_cluster_auth" "this" { name = local.cluster_name }

data "aws_route53_zone" "project" { name = local.project.zone_name }

data "aws_iam_policy" "system_administrator" { name = "SystemAdministrator" }

##### Locals
locals {
  atlantis_url                       = "atlantis.${local.project.zone_name}"
  aws_profile                        = data.terraform_remote_state.eks_cluster.outputs.aws_profile
  aws_region                         = data.terraform_remote_state.eks_cluster.outputs.aws_region
  cluster_certificate_authority_data = data.terraform_remote_state.eks_cluster.outputs.cluster_certificate_authority_data
  cluster_endpoint                   = data.terraform_remote_state.eks_cluster.outputs.cluster_endpoint
  cluster_name                       = data.terraform_remote_state.eks_cluster.outputs.cluster_name
  cluster_oidc_provider_arn          = data.terraform_remote_state.eks_cluster.outputs.cluster_oidc_provider_arn
  cluster_version                    = data.terraform_remote_state.eks_cluster.outputs.cluster_version
  eks_users                          = data.terraform_remote_state.eks_cluster.outputs.eks_users
  project                            = data.terraform_remote_state.eks_cluster.outputs.project
  project_zone_ssl_cert_arn          = data.terraform_remote_state.eks_cluster.outputs.project_zone_ssl_cert_arn
  resource_prefix                    = data.terraform_remote_state.eks_cluster.outputs.resource_prefix
}
