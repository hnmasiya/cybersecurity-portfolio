### 1. Required APIs #################################################

resource "google_project_service" "apis" {
  for_each = toset([
    "compute.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "iap.googleapis.com",
    "storage.googleapis.com",
    "oslogin.googleapis.com",
  ])
  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

### 2. Network foundation #############################################
# A custom VPC, not the project's auto-created "default" network - the
# default network ships with implicit permissive firewall rules that
# undercut everything below it.

resource "google_compute_network" "lab" {
  name                    = var.network_name
  project                 = var.project_id
  auto_create_subnetworks = false
  depends_on              = [google_project_service.apis]
}

resource "google_compute_subnetwork" "lab" {
  name          = "subnet-lab"
  project       = var.project_id
  network       = google_compute_network.lab.id
  region        = var.default_region
  ip_cidr_range = var.subnet_cidr

  # Lets the VM (which has no external IP - see the instance resource
  # below) still reach Google APIs directly rather than needing NAT for them.
  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

### 3. Firewall: deny-by-default, IAP-only SSH ########################
# No rule here ever opens SSH (or anything else) to 0.0.0.0/0. The VM has
# no external IP at all, and the only inbound path is IAP TCP forwarding,
# which is gated on IAM (roles/iap.tunnelResourceAccessor) rather than a
# source-IP allowlist that goes stale the moment the admin's IP changes.

resource "google_compute_firewall" "deny_all_ingress" {
  name      = "deny-all-ingress"
  project   = var.project_id
  network   = google_compute_network.lab.id
  priority  = 65534
  direction = "INGRESS"

  deny {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_iap_ssh" {
  name      = "allow-iap-ssh"
  project   = var.project_id
  network   = google_compute_network.lab.id
  priority  = 1000
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [var.iap_ssh_range]
  target_tags   = ["iap-ssh"]
}

resource "google_compute_firewall" "allow_internal" {
  name      = "allow-internal"
  project   = var.project_id
  network   = google_compute_network.lab.id
  priority  = 1000
  direction = "INGRESS"

  allow {
    protocol = "tcp"
  }
  allow {
    protocol = "udp"
  }
  allow {
    protocol = "icmp"
  }

  source_ranges = [var.subnet_cidr]
}

### 4. Cloud NAT ######################################################
# The VM has no external IP (deny-by-default posture), so it needs NAT to
# reach the internet for package installs/updates without ever being
# reachable from it.

resource "google_compute_router" "nat_router" {
  name    = "router-${var.default_region}"
  project = var.project_id
  region  = var.default_region
  network = google_compute_network.lab.id
}

resource "google_compute_router_nat" "nat" {
  name                               = "nat-${var.default_region}"
  project                            = var.project_id
  router                             = google_compute_router.nat_router.name
  region                             = var.default_region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

### 5. Least-privilege service account for the VM #####################
# A custom service account scoped to only what the VM actually needs
# (writing its own logs/metrics), instead of the project's broad-scope
# default Compute Engine service account.

resource "google_service_account" "vm" {
  project      = var.project_id
  account_id   = "lab-vm-sa"
  display_name = "GCP Project Security Lab VM service account"
}

resource "google_project_iam_member" "vm_log_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.vm.email}"
}

resource "google_project_iam_member" "vm_metric_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.vm.email}"
}

### 6. OS Login (project-wide) ########################################

resource "google_compute_project_metadata_item" "os_login" {
  project = var.project_id
  key     = "enable-oslogin"
  value   = "TRUE"
}

### 7. Hardened VM #####################################################
# Shielded VM (secure boot, vTPM, integrity monitoring), no external IP,
# OS Login instead of SSH keys in metadata, a scoped-down service account,
# and a startup script that installs the Cloud Ops Agent so real
# logs/metrics reach Cloud Logging/Monitoring without a manual step.

resource "google_compute_instance" "lab" {
  name         = var.vm_name
  project      = var.project_id
  zone         = var.default_zone
  machine_type = var.vm_machine_type
  tags         = ["iap-ssh"]
  labels       = var.labels

  boot_disk {
    initialize_params {
      image = var.vm_image
    }
  }

  network_interface {
    network    = google_compute_network.lab.id
    subnetwork = google_compute_subnetwork.lab.id
    # No access_config block = no external IP.
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  service_account {
    email  = google_service_account.vm.email
    scopes = ["cloud-platform"]
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    set -euo pipefail
    curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
    bash add-google-cloud-ops-agent-repo.sh --also-install
  EOT

  depends_on = [
    google_project_service.apis,
    google_compute_router_nat.nat,
  ]
}

### 8. Hardened storage bucket #########################################

resource "google_storage_bucket" "lab" {
  name     = var.bucket_name
  project  = var.project_id
  location = var.default_region

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  versioning {
    enabled = true
  }

  labels = var.labels
}

### 9. Logging retention ###############################################

resource "google_logging_project_bucket_config" "default_retention" {
  project        = var.project_id
  location       = "global"
  bucket_id      = "_Default"
  retention_days = var.log_retention_days
  depends_on     = [google_project_service.apis]
}
