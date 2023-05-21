# terraform-eks-lab/kubernetes

This module is used to deploy Kubernetes resources to an EKS cluster.
**/

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.4.0 |
| aws | ~> 4.67 |
| helm | ~> 2.9 |

## Providers

| Name | Version |
|------|---------|
| aws | 4.67.0 |
| helm | 2.9.0 |
| kubernetes | 2.20.0 |
| terraform | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| atlantis\_irsa\_role | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | ~> 5.19 |
| external\_dns\_irsa\_role | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | ~> 5.19 |
| load\_balancer\_controller\_irsa\_role | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | ~> 5.19 |

## Resources

| Name | Type |
|------|------|
| [helm_release.atlantis](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.aws_load_balancer_controller](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.external_dns](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_manifest.aws_load_balancer_controller_service_account](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |

## Inputs

No inputs.

## Outputs

No outputs.
