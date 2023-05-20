locals {
  resource_prefix = var.project.name
  azs             = formatlist("${data.aws_region.current.name}%s", var.vpc.azs)

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
