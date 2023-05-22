atlantis_values = {
  org_allowlist = "github.com/dyegoe/terraform-eks-lab"
  log_level     = "info"
  resource = {
    cpu    = "100m"
    memory = "1Gi"
  }
  volume_claim = {
    data_storage = "5Gi"
  }
  ingress_alb = {
    scheme = "internet-facing"
  }
}
