/**
* # terraform-eks-lab/kubernetes
*
**/

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

##### Data Sources
data "terraform_remote_state" "eks_cluster" {
  backend = "local"
  config = {
    path = "../eks-cluster/terraform.tfstate"
  }
}

data "aws_eks_cluster" "this" {
  name = local.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = local.cluster_name
}

data "aws_route53_zone" "project" {
  name = local.project.zone_name
}

##### Terraform
terraform {
  required_version = "~> 1.4.0"
  required_providers {
    aws = "~> 4.67"
    # kubernetes = "~> 2.0"
    helm = "~> 2.9"
  }
}

##### Providers
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

##### EKS Service Accounts
module "load_balancer_controller_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                              = "${local.resource_prefix}-${local.cluster_name}-load-balancer-controller"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = local.cluster_oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

module "external_dns_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                     = "${local.resource_prefix}-${local.cluster_name}-external-dns"
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = [data.aws_route53_zone.project.arn]

  oidc_providers = {
    ex = {
      provider_arn               = local.cluster_oidc_provider_arn
      namespace_service_accounts = ["kube-system:external-dns"]
    }
  }
}

##### Kubernetes
resource "kubernetes_manifest" "aws_load_balancer_controller_service_account" {
  manifest = {
    apiVersion = "v1"
    kind       = "ServiceAccount"
    metadata = {
      name      = "aws-load-balancer-controller"
      namespace = "kube-system"
      annotations = {
        "eks.amazonaws.com/role-arn" = module.load_balancer_controller_irsa_role.iam_role_arn
      }
    }
  }
}

##### Helm aws-load-balancer-controller
resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"

  set {
    name  = "clusterName"
    value = local.cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }
}

resource "helm_release" "external_dns" {
  name       = "external-dns"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"

  values = [
    <<EOF
    serviceAccount:
      annotations:
        eks.amazonaws.com/role-arn: ${module.external_dns_irsa_role.iam_role_arn}
    domainFilters:
      - ${local.project.zone_name}
    EOF
  ]
}
