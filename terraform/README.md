# terraform-eks-lab/terraform

This repository contains Terraform code to create an EKS cluster with managed node groups.
It will also create a VPC with public and private subnets across multiple availability zones.

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.4.0 |
| aws | ~> 4.67 |

## Providers

| Name | Version |
|------|---------|
| aws | 4.67.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| eks | terraform-aws-modules/eks/aws | ~> 19.0 |
| vpc | terraform-aws-modules/vpc/aws | 4.0.2 |

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
| eks\_managed\_node\_groups | A list of objects containing EKS node group information. Tags are applied to all resources for the EKS node group. | ```object({ defaults = object({ instance_types = list(string) }) nodes = list(object({ name = string instance_types = optional(list(string)) min_size = optional(number) max_size = optional(number) desired_size = optional(number) capacity_type = optional(string) tags = optional(map(string)) })) })``` | n/a | yes |
| eks\_user\_policies | A map of lists of objects containing EKS user policy information. Tags are applied to all resources for the EKS user policy. | ```map(list( object({ actions = list(string) resources = list(string) tags = optional(map(string)) }) ))``` | n/a | yes |
| eks\_users | A list of objects containing EKS user information. Tags are applied to all resources for the EKS user. | ```list(object({ name = string policies = list(string) k8s_groups = list(string) tags = optional(map(string)) }))``` | n/a | yes |
| project | A object containing project information. The zone\_name must be a Route53 zone that you own and is already configured in your AWS account. The project name is used as a prefix for all resources. The default tags are applied to all resources. | ```object({ name = string default_tags = map(string) zone_name = string })``` | n/a | yes |
| vpc | A object containing VPC information. AZs must be a letter that represents the AZ. For example: ["a", "b", "c"]. Number of private/public subnets must match the number of availability zones. Tags are applied to all resources for the VPC. | ```object({ cidr = string azs = list(string) private_subnets = list(string) public_subnets = list(string) private_subnet_tags = optional(map(string)) public_subnet_tags = optional(map(string)) tags = optional(map(string)) })``` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| aws\_eks\_update\_kubeconfig | the command to update the kubeconfig |
| cluster\_certificate\_authority\_data | value of the cluster\_certificate\_authority\_data |
| cluster\_endpoint | value of the cluster\_endpoint |
| cluster\_name | value of the cluster\_name |
| cluster\_version | value of the cluster\_version |
| eks\_users | n/a |
| region | value of the region |
