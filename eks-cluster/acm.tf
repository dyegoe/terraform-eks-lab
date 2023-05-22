module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.3"

  domain_name = var.project.zone_name
  zone_id     = data.aws_route53_zone.project.zone_id

  subject_alternative_names = ["*.${var.project.zone_name}"]

  wait_for_validation = true
}
