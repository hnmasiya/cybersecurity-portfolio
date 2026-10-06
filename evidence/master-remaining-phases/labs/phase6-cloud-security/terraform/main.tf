terraform {
  required_version = ">= 1.5.0"
}

# Portfolio training fixture only. It does not create cloud resources.
# The intent is to practice IaC review and secure defaults without deployment.

variable "environment" {
  type    = string
  default = "lab"
}

locals {
  security_requirements = {
    encryption_at_rest   = true
    public_storage       = false
    least_privilege      = true
    logging_enabled      = true
    network_segmentation = true
  }
}

output "security_requirements" {
  value = local.security_requirements
}
