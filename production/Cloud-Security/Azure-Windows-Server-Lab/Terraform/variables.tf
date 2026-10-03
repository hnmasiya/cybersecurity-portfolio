variable "resource_group_name" {
  description = "Name of the resource group the lab is deployed into."
  type        = string
  default     = "rg-winserver-security-lab"
}

variable "location" {
  description = "Azure region for all lab resources."
  type        = string
  default     = "eastus"
}

variable "vm_name" {
  description = "Hostname of the Windows Server VM."
  type        = string
  default     = "dc01-lab"
}

variable "vm_size" {
  description = "VM SKU. Standard_B2s is deliberately small/cheap for a lab that isn't running production load."
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Local administrator account created on the VM."
  type        = string
  default     = "labadmin"
}

variable "admin_password" {
  description = "Local administrator password. No default on purpose — must be supplied via terraform.tfvars (gitignored) or -var at apply time, never committed."
  type        = string
  sensitive   = true
}

variable "admin_source_ip" {
  description = "Your current public IP in CIDR form (e.g. \"203.0.113.10/32\"), used to lock down inbound RDP. No default on purpose — RDP must never be opened to 0.0.0.0/0."
  type        = string

  validation {
    condition     = can(cidrhost(var.admin_source_ip, 0))
    error_message = "admin_source_ip must be a valid CIDR block, e.g. 203.0.113.10/32."
  }
}

variable "auto_shutdown_time" {
  description = "Daily auto-shutdown time in 24h HHmm, VM timezone. Keeps a forgotten lab VM from running (and billing) indefinitely."
  type        = string
  default     = "1900"
}

variable "auto_shutdown_timezone" {
  description = "Timezone used to interpret auto_shutdown_time."
  type        = string
  default     = "UTC"
}

variable "tags" {
  description = "Common resource tags."
  type        = map(string)
  default = {
    project     = "windows-server-security-lab"
    environment = "lab"
    managed_by  = "terraform"
  }
}
