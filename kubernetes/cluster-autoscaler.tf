module "cluster_autoscaler_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.19"

  role_name                        = "${local.cluster_name}-cluster-autoscaler" # local.cluster_name already includes the resource_prefix
  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_names = [local.cluster_name]

  oidc_providers = {
    (local.cluster_name) = {
      provider_arn               = local.cluster_oidc_provider_arn
      namespace_service_accounts = ["kube-system:cluster-autoscaler"]
    }
  }
}

resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  namespace  = "kube-system"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"

  values = [
    <<EOF
    autoDiscovery:
      clusterName: ${local.cluster_name}
    rbac:
      serviceAccount:
        annotations:
          eks.amazonaws.com/role-arn: ${module.cluster_autoscaler_irsa_role.iam_role_arn}
    EOF
  ]
}
