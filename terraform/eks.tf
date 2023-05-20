locals {
  eks_managed_node_groups = {
    for node in var.eks_managed_node_groups.nodes : node.name => {
      name         = "${local.resource_prefix}-${node.name}"
      min_size     = try(node.min_size, 1)
      max_size     = try(node.max_size, 3)
      desired_size = try(node.desired_size, 1)

      instance_types = try(node.instance_types, var.eks_managed_node_groups.defaults.instance_types)
      capacity_type  = try(node.capacity_type, "ON_DEMAND")

      tags = try(node.tags, {})
    }
  }
}

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

  tags = try(var.eks.additional_tags, {})
}
