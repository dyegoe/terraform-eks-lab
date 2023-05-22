provider "aws" {
  region = "eu-north-1"
}

data "aws_instance" "eks_instances" {
  filter {
    name   = "tag:eks:cluster-name"
    values = ["my-lab-eun1-1-eks"]
  }
}

output "instances" {
  value = data.aws_instance.eks_instances
}
