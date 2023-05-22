output "aws_profile" {
  value       = var.aws_profile
  description = "current aws profile"
}

output "aws_region" {
  value       = var.aws_region
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

output "cluster_oidc_provider_arn" {
  value       = module.eks.oidc_provider_arn
  description = "EKS cluster OIDC provider ARN"
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

output "project" {
  value       = var.project
  description = "project information"
}

output "project_zone_ssl_cert_arn" {
  value       = module.acm.acm_certificate_arn
  description = "project zone ssl cert arn"
}

output "resource_prefix" {
  value       = local.resource_prefix
  description = "resource prefix"
}

output "update_kubeconfig" {
  value       = "aws --region ${data.aws_region.current.name} eks update-kubeconfig --name ${module.eks.cluster_name}"
  description = "the command to update the kubeconfig"
}
