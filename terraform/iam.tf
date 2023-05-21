##### EKS Users
data "aws_iam_policy_document" "assume_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}

data "aws_iam_policy_document" "eks_user_policies" {
  for_each = var.eks_user_policies

  dynamic "statement" {
    for_each = each.value
    content {
      actions   = statement.value.actions
      resources = statement.value.resources
    }
  }
}

resource "aws_iam_policy" "eks_user_policies" {
  for_each = var.eks_user_policies

  name        = "${local.resource_prefix}-${var.eks.cluster_name}-${each.key}"
  path        = "/${local.resource_prefix}/eks/${var.eks.cluster_name}/"
  description = "Policy managed by Terraform - aws_iam_policy.eks_user_policies - var.eks_user_policies"
  policy      = data.aws_iam_policy_document.eks_user_policies[each.key].json
  tags        = try(each.value.tags, {})
}

resource "aws_iam_role" "eks_user" {
  for_each = { for user in var.eks_users : user.name => user }

  name               = "${local.resource_prefix}-${var.eks.cluster_name}-${each.key}"
  path               = "/${local.resource_prefix}/eks/${var.eks.cluster_name}/"
  description        = "Role managed by Terraform - aws_iam_role.eks_user - var.eks_users"
  assume_role_policy = data.aws_iam_policy_document.assume_policy.json
  tags               = try(each.value.tags, {})
}

resource "aws_iam_role_policy_attachment" "eks_user" {
  for_each = {
    for u in flatten(
      [
        for user in var.eks_users : [
          for policy in user.policies : {
            name   = user.name
            policy = policy
          }
        ]
      ]
    ) : "${u.name}_${u.policy}" => u
  }

  role       = aws_iam_role.eks_user[each.value.name].name
  policy_arn = aws_iam_policy.eks_user_policies[each.value.policy].arn
}
