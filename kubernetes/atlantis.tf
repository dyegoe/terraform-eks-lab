module "atlantis_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.19"

  role_name = "${local.resource_prefix}-${local.cluster_name}-atlantis"
  role_policy_arns = {
    policy = data.aws_iam_policy.system_administrator.arn
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

  values = [
    templatefile("${path.module}/templates/values.yaml", {
      org_allowlist               = var.atlantis_values.org_allowlist
      log_level                   = var.atlantis_values.log_level
      github_user                 = var.github.user
      github_token                = var.github.token
      github_secret               = var.github.secret
      basic_auth_username         = var.atlantis_basic_auth.username
      basic_auth_password         = var.atlantis_basic_auth.password
      ingress_alb_scheme          = var.atlantis_values.ingress_alb.scheme
      ingress_alb_certificate_arn = local.project_zone_ssl_cert_arn
      ingress_alb_hostname        = "atlantis.${local.project.zone_name}"
      resource_memory             = var.atlantis_values.resource.memory
      resource_cpu                = var.atlantis_values.resource.cpu
      volume_claim_data_storage   = var.atlantis_values.volume_claim.data_storage
      atlantis_irsa_role          = module.atlantis_irsa_role.iam_role_arn
    })
  ]

  depends_on = [
    helm_release.aws_load_balancer_controller,
    helm_release.external_dns
  ]
}
