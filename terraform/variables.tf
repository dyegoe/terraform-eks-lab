##### AWS
variable "aws_region" {
  type        = string
  description = "AWS region to deploy to."
  default     = "us-east-1"
}

variable "aws_profile" {
  type        = string
  description = "AWS profile to use."
  default     = "default"
}

##### Project
variable "project" {
  type = object({
    name         = string
    default_tags = map(string)
    zone_name    = string
  })
  description = "A object containing project information. The zone_name must be a Route53 zone that you own and is already configured in your AWS account. The project name is used as a prefix for all resources. The default tags are applied to all resources."
}

##### VPC
variable "vpc" {
  type = object({
    cidr                = string
    azs                 = list(string)
    private_subnets     = list(string)
    public_subnets      = list(string)
    private_subnet_tags = optional(map(string))
    public_subnet_tags  = optional(map(string))
    additional_tags     = optional(map(string))
  })
  description = "A object containing VPC information. AZs must be a letter that represents the AZ. For example: [\"a\", \"b\", \"c\"]. Number of private/public subnets must match the number of availability zones. The additional tags are applied to all resources for the VPC."

  validation {
    condition     = alltrue([for az in var.vpc.azs : can(regex("^[a-z]$", az))])
    error_message = "The list of AZs must be a letter that represents the AZ. For example: [\"a\", \"b\", \"c\"]"
  }

  validation {
    condition     = length(var.vpc.azs) == length(var.vpc.private_subnets)
    error_message = "Number of private subnets must match the number of availability zones"
  }

  validation {
    condition     = length(var.vpc.azs) == length(var.vpc.public_subnets)
    error_message = "Number of public subnets must match the number of availability zones"
  }
}
