output "region" {
  value       = data.aws_region.current.name
  description = "value of the region"
}

output "cluster_name" {
  value       = module.eks.cluster_name
  description = "value of the cluster_name"
}

output "cluster_version" {
  value       = module.eks.cluster_version
  description = "value of the cluster_version"
}

output "cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "value of the cluster_endpoint"
}

output "cluster_certificate_authority_data" {
  value       = module.eks.cluster_certificate_authority_data
  description = "value of the cluster_certificate_authority_data"
}

output "aws_eks_update_kubeconfig" {
  value       = "aws --region ${data.aws_region.current} eks update-kubeconfig --name ${module.eks.cluster_name}"
  description = "the command to update the kubeconfig"
}
