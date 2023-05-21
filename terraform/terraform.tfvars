##### AWS
aws_region  = "eu-north-1"
aws_profile = "default"

##### Project
project = {
  name      = "my-lab"
  zone_name = "aws.dyego.com.br"
  default_tags = {
    Terraform   = "true"
    Environment = "lab"
    Team        = "Platform Engineering"
  }
}

##### VPC
vpc = {
  cidr            = "10.85.0.0/16"
  azs             = ["a", "b"]
  private_subnets = ["10.85.0.0/18", "10.85.64.0/18"]
  public_subnets  = ["10.85.254.0/24", "10.85.255.0/24"]
}

##### EKS
eks = {
  cluster_name                    = "eun1-1"
  cluster_version                 = "1.26"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
}

eks_managed_node_groups = {
  defaults = {
    instance_types = ["t3.small"]
  }
  nodes = [
    {
      name          = "nodes"
      min_size      = 1
      max_size      = 3
      desired_size  = 1
      capacity_type = "SPOT"
      tags = {
        example = "true"
      }
    }
  ]
}

eks_user_groups = {
  admin = [
    { actions = ["eks:*"], resources = ["*"] }
  ]
  readonly = [
    {
      actions = [
        "eks:ListFargateProfiles",
        "eks:DescribeNodegroup",
        "eks:ListNodegroups",
        "eks:DescribeFargateProfile",
        "eks:ListTagsForResource",
        "eks:ListUpdates",
        "eks:DescribeUpdate",
        "eks:DescribeCluster",
        "eks:ListClusters",
        "eks:AccessKubernetesApi",
        "eks:GetParameter"
      ]
      resources = ["*"]
    }
  ]
}

eks_users = [
  { name = "admin", groups = ["admin"] },
  { name = "readonly", groups = ["readonly"] },
  { name = "test", groups = ["admin", "readonly"] }
]
