module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "${local.resource_prefix}-${var.eks.cluster_name}-eks"
  cluster_version = var.eks.cluster_version

  cluster_endpoint_private_access = var.eks.cluster_endpoint_private_access
  cluster_endpoint_public_access  = var.eks.cluster_endpoint_public_access

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    instance_types = try(var.eks_managed_node_groups.defaults.instance_types, ["t3.medium"])
  }

  eks_managed_node_groups = local.eks_managed_node_groups

  manage_aws_auth_configmap = true
  aws_auth_roles = [
    for user in var.eks_users : {
      username = user.name
      groups   = user.k8s_groups
      rolearn  = aws_iam_role.eks_user[user.name].arn
    }
  ]

  tags = try(var.eks.tags, {})
}
