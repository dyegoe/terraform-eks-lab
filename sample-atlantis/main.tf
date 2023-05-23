/*
* # Just an example of how to list instances in a cluster
*/

terraform {
  backend "s3" {
    bucket = "dyego-terraform"
    key    = "terraform-eks-lab/sample-atlantis/terraform.tfstate"
    region = "us-east-1"
  }

  required_version = "~> 1.4.0"
  required_providers {
    aws = "~> 4.67"
  }
}

provider "aws" {
  region = "eu-north-1"
}

data "aws_instances" "eks_instances" {
  filter {
    name   = "tag:eks:cluster-name"
    values = ["my-lab-eun1-1-eks"]
  }
}

output "instances" {
  value = data.aws_instances.eks_instances.ids
}
