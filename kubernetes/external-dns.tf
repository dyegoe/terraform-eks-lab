module "external_dns_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.19"

  role_name                     = "${local.resource_prefix}-${local.cluster_name}-external-dns"
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = [data.aws_route53_zone.project.arn]

  oidc_providers = {
    (local.cluster_name) = {
      provider_arn               = local.cluster_oidc_provider_arn
      namespace_service_accounts = ["kube-system:external-dns"]
    }
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
