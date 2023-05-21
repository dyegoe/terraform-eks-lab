module "atlantis_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.19"

  role_name = "${local.resource_prefix}-${local.cluster_name}-atlantis"
  role_policy_arns = {
    policy = data.aws_iam_policy.administrator_access.arn
  }
  oidc_providers = {
    (local.cluster_name) = {
      provider_arn               = local.cluster_oidc_provider_arn
      namespace_service_accounts = ["atlantis:atlantis"]
    }
  }
}

resource "helm_release" "atlantis" {
  name       = "atlantis"
  namespace  = "atlantis"
  repository = "https://runatlantis.github.io/helm-charts"
  chart      = "atlantis"

  create_namespace = true

  values = []
}
