variable "org_id" {
  description = "GCP Organization ID all resources are created under. No default on purpose — must be supplied via terraform.tfvars (gitignored) or -var at apply time."
  type        = string
}

variable "billing_account" {
  description = "Billing account ID linked to every project this landing zone creates. No default on purpose."
  type        = string
}

variable "default_region" {
  description = "Default region for regional resources (subnets, Cloud NAT, logging bucket)."
  type        = string
  default     = "us-central1"
}

variable "domain" {
  description = "Primary Google Workspace/Cloud Identity domain, used to scope the iam.allowedPolicyMemberDomains org policy so principals outside this domain can't be granted IAM roles anywhere in the org."
  type        = string
}

variable "folder_structure" {
  description = "Top-level folder names under the organization. Kept as a variable rather than hardcoded so environments can be renamed without touching resource logic."
  type = object({
    bootstrap   = string
    common      = string
    production  = string
    nonprod     = string
    development = string
  })
  default = {
    bootstrap   = "fldr-bootstrap"
    common      = "fldr-common"
    production  = "fldr-production"
    nonprod     = "fldr-nonprod"
    development = "fldr-development"
  }
}

variable "shared_vpc_host_project_id" {
  description = "Project ID for the Shared VPC host project. Must be globally unique; no default on purpose."
  type        = string
}

variable "network_name" {
  description = "Name of the Shared VPC network created in the host project."
  type        = string
  default     = "vpc-shared-prod"
}

variable "subnets" {
  description = "Subnets created inside the Shared VPC, keyed by name. Deliberately small, non-overlapping ranges — this is a landing zone foundation, not a production sizing exercise."
  type = map(object({
    region        = string
    ip_cidr_range = string
  }))
  default = {
    "subnet-app-us-central1" = {
      region        = "us-central1"
      ip_cidr_range = "10.10.0.0/24"
    }
    "subnet-data-us-central1" = {
      region        = "us-central1"
      ip_cidr_range = "10.10.1.0/24"
    }
  }
}

variable "logging_project_id" {
  description = "Project ID for the centralized logging/security project that receives the org-level aggregated log sink. No default on purpose — must be globally unique."
  type        = string
}

variable "log_retention_days" {
  description = "Retention period for the centralized logging bucket."
  type        = number
  default     = 400
}

variable "labels" {
  description = "Common labels applied to every project this landing zone creates."
  type        = map(string)
  default = {
    managed_by   = "terraform"
    landing_zone = "true"
  }
}
