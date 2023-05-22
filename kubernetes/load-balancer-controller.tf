module "load_balancer_controller_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.19"

  role_name                              = "${local.resource_prefix}-${local.cluster_name}-load-balancer-controller"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    (local.cluster_name) = {
      provider_arn               = local.cluster_oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"

  values = [
    <<YAML
    clusterName: ${local.cluster_name}
    serviceAccount:
      create: true
      name: aws-load-balancer-controller
      annotations:
        eks.amazonaws.com/role-arn: ${module.load_balancer_controller_irsa_role.iam_role_arn}
    YAML
  ]
}
