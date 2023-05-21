# terraform-eks-lab/eks-cluster

This repository contains Terraform code to create an EKS cluster with managed node groups.
It will also create a VPC with public and private subnets across multiple availability zones.

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.4.0 |
| aws | ~> 4.67 |
| kubernetes | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 4.67.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| ebs\_csi\_irsa\_role | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | ~> 5.19 |
| eks | terraform-aws-modules/eks/aws | ~> 19.0 |
| vpc | terraform-aws-modules/vpc/aws | ~> 4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_policy.eks_user_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.eks_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.eks_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_profile | AWS profile to use. | `string` | `"default"` | no |
| aws\_region | AWS region to deploy to. | `string` | `"us-east-1"` | no |
| eks | A object containing EKS information. Tags are applied to all resources for the EKS cluster. | ```object({ cluster_name = string cluster_version = string cluster_endpoint_private_access = bool cluster_endpoint_public_access = bool tags = optional(map(string)) })``` | n/a | yes |
| eks\_managed\_node\_groups | A object containing EKS managed node group information. `defaults` and `nodes` are objects. The `defaults` are applied to all node groups. The `nodes` key is used as name if name is not provided. | ```object({ defaults = any nodes = any })``` | n/a | yes |
| eks\_user\_policies | A map of lists of objects containing EKS user policy information. Tags are applied to all resources for the EKS user policy. | ```map(list( object({ actions = list(string) resources = list(string) tags = optional(map(string)) }) ))``` | n/a | yes |
| eks\_users | A list of objects containing EKS user information. Tags are applied to all resources for the EKS user. | ```list(object({ name = string policies = list(string) k8s_groups = list(string) tags = optional(map(string)) }))``` | n/a | yes |
| project | A object containing project information. The zone\_name must be a Route53 zone that you own and is already configured in your AWS account. The project name is used as a prefix for all resources. The default tags are applied to all resources. | ```object({ name = string default_tags = map(string) zone_name = string })``` | n/a | yes |
| vpc | A object containing VPC information. AZs must be a letter that represents the AZ. For example: ["a", "b", "c"]. Number of private/public subnets must match the number of availability zones. Tags are applied to all resources for the VPC. | ```object({ cidr = string azs = list(string) private_subnets = list(string) public_subnets = list(string) private_subnet_tags = optional(map(string)) public_subnet_tags = optional(map(string)) tags = optional(map(string)) })``` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| aws\_profile | current aws profile |
| aws\_region | current aws region |
| cluster\_certificate\_authority\_data | EKS cluster certificate authority data |
| cluster\_endpoint | EKS cluster endpoint |
| cluster\_name | EKS cluster name |
| cluster\_oidc\_provider\_arn | EKS cluster OIDC provider ARN |
| cluster\_version | EKS cluster version |
| eks\_users | list of eks users and their arns |
| project | project information |
| resource\_prefix | resource prefix |
| update\_kubeconfig | the command to update the kubeconfig |
