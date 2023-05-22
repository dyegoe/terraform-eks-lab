variable "github" {
  type = object({
    user   = string
    token  = string
    secret = string
  })
  description = "GitHub credentials for Atlantis"
}

variable "atlantis_basic_auth" {
  type = object({
    username = string
    password = string
  })
  description = "Basic auth credentials for Atlantis"
}

variable "atlantis_values" {
  type = object({
    org_allowlist = string
    log_level     = string
    ingress_alb = object({
      scheme = string
    })
    resource = object({
      memory = string
      cpu    = string
    })
    volume_claim = object({
      data_storage = string
    })
  })
  description = "Atlantis Helm chart values"
}
