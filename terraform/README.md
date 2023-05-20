# terraform-eks-lab/terraform

This repository will create a VPC with public and private subnets across multiple availability zones. It also creates a NAT gateway and an internet gateway for the public subnets. The private subnets have a route to the NAT gateway to allow internet access.

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
| vpc | terraform-aws-modules/vpc/aws | 4.0.2 |

## Resources

| Name | Type |
|------|------|
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_profile | AWS profile to use. | `string` | `"default"` | no |
| aws\_region | AWS region to deploy to. | `string` | `"us-east-1"` | no |
| project | A object containing project information. The zone\_name must be a Route53 zone that you own and is already configured in your AWS account. The project name is used as a prefix for all resources. The default tags are applied to all resources. | ```object({ name = string default_tags = map(string) zone_name = string })``` | n/a | yes |
| vpc | A object containing VPC information. AZs must be a letter that represents the AZ. For example: ["a", "b", "c"]. Number of private/public subnets must match the number of availability zones. The additional tags are applied to all resources for the VPC. | ```object({ cidr = string azs = list(string) private_subnets = list(string) public_subnets = list(string) private_subnet_tags = optional(map(string)) public_subnet_tags = optional(map(string)) additional_tags = optional(map(string)) })``` | n/a | yes |

## Outputs

No outputs.
