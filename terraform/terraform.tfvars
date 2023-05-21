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
    ami_type       = "AL2_x86_64"
    instance_types = ["t3.small"]
    min_size       = 1
    max_size       = 3
    desired_size   = 1
    capacity_type  = "SPOT"
    iam_role_additional_policies = {
      AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    }
  }
  nodes = {
    work-node = {}
  }
}

eks_user_policies = {
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
  { name = "admin", policies = ["admin"], k8s_groups = ["system:master"] },
  { name = "readonly", policies = ["readonly"], k8s_groups = ["system:readonly"] },
]
