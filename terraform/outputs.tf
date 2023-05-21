output "aws_region" {
  value       = data.aws_region.current.name
  description = "current aws region"
}

output "cluster_name" {
  value       = module.eks.cluster_name
  description = "EKS cluster name"
}

output "cluster_version" {
  value       = module.eks.cluster_version
  description = "EKS cluster version"
}

output "cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "EKS cluster endpoint"
}

output "cluster_certificate_authority_data" {
  value       = module.eks.cluster_certificate_authority_data
  description = "EKS cluster certificate authority data"
}

output "eks_users" {
  value = [
    for k, v in aws_iam_role.eks_user : {
      name = k
      arn  = v.arn
    }
  ]
  description = "list of eks users and their arns"
}

output "update_kubeconfig" {
  value       = "aws --region ${data.aws_region.current.name} eks update-kubeconfig --name ${module.eks.cluster_name}"
  description = "the command to update the kubeconfig"
}
