/**
* # terraform-eks-lab/kubernetes
*
* This module is used to deploy Kubernetes resources to an EKS cluster.
**/

terraform {
  required_version = "~> 1.4.0"
  required_providers {
    aws = "~> 4.67"
    # kubernetes = "~> 2.0"
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

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.this.name]
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
  backend = "local"
  config  = { path = "../eks-cluster/terraform.tfstate" }
}

data "aws_eks_cluster" "this" { name = local.cluster_name }

data "aws_eks_cluster_auth" "this" { name = local.cluster_name }

data "aws_route53_zone" "project" { name = local.project.zone_name }

data "aws_iam_policy" "administrator_access" { name = "AdministratorAccess" }

##### Locals
locals {
  aws_profile                        = data.terraform_remote_state.eks_cluster.outputs.aws_profile
  aws_region                         = data.terraform_remote_state.eks_cluster.outputs.aws_region
  cluster_certificate_authority_data = data.terraform_remote_state.eks_cluster.outputs.cluster_certificate_authority_data
  cluster_endpoint                   = data.terraform_remote_state.eks_cluster.outputs.cluster_endpoint
  cluster_name                       = data.terraform_remote_state.eks_cluster.outputs.cluster_name
  cluster_oidc_provider_arn          = data.terraform_remote_state.eks_cluster.outputs.cluster_oidc_provider_arn
  cluster_version                    = data.terraform_remote_state.eks_cluster.outputs.cluster_version
  eks_users                          = data.terraform_remote_state.eks_cluster.outputs.eks_users
  project                            = data.terraform_remote_state.eks_cluster.outputs.project
  resource_prefix                    = data.terraform_remote_state.eks_cluster.outputs.resource_prefix
}
