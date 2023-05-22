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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| atlantis\_basic\_auth | Basic auth credentials for Atlantis | ```object({ username = string password = string })``` | n/a | yes |
| atlantis\_values | Atlantis Helm chart values | ```object({ org_allowlist = string log_level = string ingress_alb = object({ scheme = string }) resource = object({ memory = string cpu = string }) volume_claim = object({ data_storage = string }) })``` | n/a | yes |
| github | GitHub credentials for Atlantis | ```object({ user = string token = string secret = string })``` | n/a | yes |

## Outputs

No outputs.
