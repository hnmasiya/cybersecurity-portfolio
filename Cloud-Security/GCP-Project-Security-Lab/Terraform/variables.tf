variable "project_id" {
  description = "Existing standalone GCP project this lab deploys into. No default on purpose — must be supplied via terraform.tfvars (gitignored) or -var at apply time. This lab is project-scoped (no google_folder/google_org_policy_policy resources) because it targets a standalone project with no Cloud Identity/Workspace organization behind it — see ../README.md for why that's a different shape than the org-level GCP-Landing-Zone-Lab."
  type        = string
}

variable "default_region" {
  description = "Region for regional resources (subnet, Cloud Router/NAT, logging bucket)."
  type        = string
  default     = "us-central1"
}

variable "default_zone" {
  description = "Zone for the lab VM."
  type        = string
  default     = "us-central1-a"
}

variable "network_name" {
  description = "Name of the custom VPC created for this lab. Deliberately not using the project's auto-created 'default' network, which ships with permissive implicit-allow firewall rules."
  type        = string
  default     = "vpc-project-security-lab"
}

variable "subnet_cidr" {
  description = "CIDR range for the lab's single subnet."
  type        = string
  default     = "10.20.0.0/24"
}

variable "vm_name" {
  description = "Name of the hardened lab VM."
  type        = string
  default     = "hardened-lab-vm"
}

variable "vm_machine_type" {
  description = "Machine type. e2-small is deliberately small/cheap for a lab that isn't running production load."
  type        = string
  default     = "e2-small"
}

variable "vm_image" {
  description = "Boot image for the lab VM."
  type        = string
  default     = "debian-cloud/debian-12"
}

variable "iap_ssh_range" {
  description = "GCP's fixed source range for Identity-Aware Proxy TCP forwarding. This is the ONLY source SSH is ever allowed from — no admin IP is opened directly, unlike a direct-SSH design. IAP tunnels the connection through Google's infrastructure and gates it on IAM (roles/iap.tunnelResourceAccessor), so this doesn't need to change when your public IP does."
  type        = string
  default     = "35.235.240.0/20"
}

variable "bucket_name" {
  description = "Name of the lab's GCS bucket. Must be globally unique across all of GCP — no default on purpose."
  type        = string
}

variable "log_retention_days" {
  description = "Retention period for the project's Cloud Logging bucket."
  type        = number
  default     = 90
}

variable "labels" {
  description = "Common labels applied to lab resources."
  type        = map(string)
  default = {
    managed_by = "terraform"
    lab        = "gcp-project-security-lab"
  }
}
