resource "aws_eip" "nat" {
  count = length(var.vpc.azs)

  vpc = true
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.2"

  name = "${local.resource_prefix}-vpc"
  cidr = var.vpc.cidr

  azs                 = local.azs
  private_subnets     = var.vpc.private_subnets
  private_subnet_tags = try(var.vpc.private_subnet_tags, {})
  public_subnets      = var.vpc.public_subnets
  public_subnet_tags  = try(var.vpc.public_subnet_tags, {})

  enable_nat_gateway  = true
  single_nat_gateway  = false
  reuse_nat_ips       = true
  external_nat_ip_ids = aws_eip.nat.*.id

  tags = try(var.vpc.additional_tags, {})
}
