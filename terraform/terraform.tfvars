##### AWS
aws_region  = "eu-north-1"
aws_profile = "default"

##### Project
project = {
  name      = "lab-eks"
  zone_name = "aws.dyego.com.br"
  default_tags = {
    "Terraform"   = "true"
    "Environment" = "lab"
    "Project"     = "lab-eks"
  }
}

##### VPC
vpc = {
  cidr            = "10.85.0.0/16"
  azs             = ["a", "b", "c"] # it will be appended to the region name
  private_subnets = ["10.85.0.0/18", "10.85.64.0/18", "10.85.128.0/18"]
  public_subnets  = ["10.85.253.0/24", "10.85.254.0/24", "10.85.255.0/24"]
}
