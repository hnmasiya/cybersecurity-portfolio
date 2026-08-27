### 1. Folder structure ############################################
# Organization -> environment folders. Kept flat (no nested "common/shared"
# sub-folders) since this landing zone doesn't yet need per-team delegation -
# that's a real future extension, not something to over-build up front.

resource "google_folder" "bootstrap" {
  display_name = var.folder_structure.bootstrap
  parent       = "organizations/${var.org_id}"
}

resource "google_folder" "common" {
  display_name = var.folder_structure.common
  parent       = "organizations/${var.org_id}"
}

resource "google_folder" "production" {
  display_name = var.folder_structure.production
  parent       = "organizations/${var.org_id}"
}

resource "google_folder" "nonprod" {
  display_name = var.folder_structure.nonprod
  parent       = "organizations/${var.org_id}"
}

resource "google_folder" "development" {
  display_name = var.folder_structure.development
  parent       = "organizations/${var.org_id}"
}

### 2. Organization-level security policy ###########################
# Guardrails that apply everywhere in the org, not just this landing zone's
# own projects - the whole point of setting these at the organization node.

resource "google_org_policy_policy" "restrict_iam_domain" {
  name   = "organizations/${var.org_id}/policies/iam.allowedPolicyMemberDomains"
  parent = "organizations/${var.org_id}"

  spec {
    rules {
      values {
        allowed_values = [var.domain]
      }
    }
  }
}

resource "google_org_policy_policy" "deny_service_account_keys" {
  name   = "organizations/${var.org_id}/policies/iam.disableServiceAccountKeyCreation"
  parent = "organizations/${var.org_id}"

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}

resource "google_org_policy_policy" "deny_external_ips" {
  name   = "organizations/${var.org_id}/policies/compute.vmExternalIpAccess"
  parent = "organizations/${var.org_id}"

  spec {
    rules {
      # Empty allowed_values with no denied_values = deny-all: no instance
      # anywhere in the org may have an external IP unless a more specific
      # policy at a lower node (folder/project) explicitly overrides it.
      values {
        allowed_values = []
      }
    }
  }
}

resource "google_org_policy_policy" "uniform_bucket_access" {
  name   = "organizations/${var.org_id}/policies/storage.uniformBucketLevelAccess"
  parent = "organizations/${var.org_id}"

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}

### 3. Bootstrap: Shared VPC host + logging projects ################

resource "google_project" "shared_vpc_host" {
  name            = "Shared VPC Host"
  project_id      = var.shared_vpc_host_project_id
  folder_id       = google_folder.common.folder_id
  billing_account = var.billing_account
  labels          = var.labels
}

resource "google_project" "logging" {
  name            = "Centralized Logging"
  project_id      = var.logging_project_id
  folder_id       = google_folder.common.folder_id
  billing_account = var.billing_account
  labels          = var.labels
}

resource "google_project_service" "host_apis" {
  for_each = toset([
    "compute.googleapis.com",
    "dns.googleapis.com",
  ])
  project = google_project.shared_vpc_host.project_id
  service = each.value
}

resource "google_project_service" "logging_apis" {
  for_each = toset([
    "logging.googleapis.com",
  ])
  project = google_project.logging.project_id
  service = each.value
}

### 4. Network foundation: Shared VPC ###############################

resource "google_compute_shared_vpc_host_project" "host" {
  project    = google_project.shared_vpc_host.project_id
  depends_on = [google_project_service.host_apis]
}

resource "google_compute_network" "shared_vpc" {
  name                    = var.network_name
  project                 = google_project.shared_vpc_host.project_id
  auto_create_subnetworks = false
  depends_on              = [google_project_service.host_apis]
}

resource "google_compute_subnetwork" "subnets" {
  for_each = var.subnets

  name          = each.key
  project       = google_project.shared_vpc_host.project_id
  network       = google_compute_network.shared_vpc.id
  region        = each.value.region
  ip_cidr_range = each.value.ip_cidr_range

  # Lets instances without an external IP still reach Google APIs -
  # the whole point of the org-wide deny-external-ips policy above only
  # working smoothly if this is turned on everywhere.
  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# Default-deny: no implicit allow-all. Everything inbound must be an
# explicit rule below this one.
resource "google_compute_firewall" "deny_all_ingress" {
  name      = "deny-all-ingress"
  project   = google_project.shared_vpc_host.project_id
  network   = google_compute_network.shared_vpc.id
  priority  = 65534
  direction = "INGRESS"

  deny {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_internal" {
  name      = "allow-internal"
  project   = google_project.shared_vpc_host.project_id
  network   = google_compute_network.shared_vpc.id
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

  source_ranges = [for s in var.subnets : s.ip_cidr_range]
}

# Cloud NAT: lets private (no-external-IP) instances reach the internet
# for updates/package installs without ever being reachable from it.
resource "google_compute_router" "nat_router" {
  for_each = var.subnets

  name    = "router-${each.value.region}"
  project = google_project.shared_vpc_host.project_id
  region  = each.value.region
  network = google_compute_network.shared_vpc.id
}

resource "google_compute_router_nat" "nat" {
  for_each = var.subnets

  name                               = "nat-${each.value.region}"
  project                            = google_project.shared_vpc_host.project_id
  router                             = google_compute_router.nat_router[each.key].name
  region                             = each.value.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

### 5. Centralized logging ###########################################
# One aggregated sink at the organization node captures every project's
# logs (including ones created later, under any folder) into one place -
# rather than relying on each project to be individually wired up.

resource "google_logging_project_bucket_config" "central" {
  project        = google_project.logging.project_id
  location       = var.default_region
  bucket_id      = "org-audit-logs"
  retention_days = var.log_retention_days
  depends_on     = [google_project_service.logging_apis]
}

resource "google_logging_organization_sink" "org_sink" {
  name             = "org-audit-log-sink"
  org_id           = var.org_id
  include_children = true

  destination = "logging.googleapis.com/${google_logging_project_bucket_config.central.id}"

  # Only ship the log types actually needed for security investigation and
  # compliance - not every log line generated org-wide.
  filter = "logName:\"cloudaudit.googleapis.com\""
}

resource "google_project_iam_member" "sink_writer" {
  project = google_project.logging.project_id
  role    = "roles/logging.bucketWriter"
  member  = google_logging_organization_sink.org_sink.writer_identity
}

### 6. Least-privilege IAM at the folder level #######################
# Bound at the folder, not per-project - so any project created later under
# an environment folder inherits the same baseline without needing to be
# individually wired into IAM.

resource "google_folder_iam_member" "production_viewers" {
  folder = google_folder.production.name
  role   = "roles/viewer"
  member = "group:security-team@${var.domain}"
}

resource "google_folder_iam_member" "logging_admins" {
  folder = google_folder.common.name
  role   = "roles/logging.admin"
  member = "group:platform-team@${var.domain}"
}
