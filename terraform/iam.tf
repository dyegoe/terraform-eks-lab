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

data "aws_iam_policy_document" "eks_user_groups" {
  for_each = var.eks_user_groups

  dynamic "statement" {
    for_each = each.value
    content {
      actions   = statement.value.actions
      resources = statement.value.resources
    }
  }
}

resource "aws_iam_policy" "eks_user_groups" {
  for_each = var.eks_user_groups

  name        = "${local.resource_prefix}-${var.eks.cluster_name}-${each.key}"
  description = "Policy for ${each.key} user"
  path        = "${local.resource_prefix}/eks/${var.eks.cluster_name}/"
  policy      = data.aws_iam_policy_document.eks_user_groups[each.key].json
  tags        = try(each.value.tags, {})
}

resource "aws_iam_role" "eks_user" {
  for_each = { for user in var.eks_users : user.name => user }

  name               = "${local.resource_prefix}-${var.eks.cluster_name}-${each.key}"
  description        = "Role for ${each.key} user"
  assume_role_policy = data.aws_iam_policy_document.assume_policy.json
  tags               = try(each.value.tags, {})
}

resource "aws_iam_role_policy_attachment" "eks_user" {
  for_each = {
    for i in flatten(
      [
        for user in var.eks_users : [
          for group in user.groups : {
            name  = user.name
            group = group
          }
        ]
      ]
    ) : "${i.name}_${i.group}" => i
  }

  role       = aws_iam_role.eks_user[each.value.name].name
  policy_arn = aws_iam_policy.eks_user_groups[each.value.group].arn
}
