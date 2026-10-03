output "folder_ids" {
  description = "Folder IDs created for each environment, keyed by role."
  value = {
    bootstrap   = google_folder.bootstrap.folder_id
    common      = google_folder.common.folder_id
    production  = google_folder.production.folder_id
    nonprod     = google_folder.nonprod.folder_id
    development = google_folder.development.folder_id
  }
}

output "shared_vpc_host_project_id" {
  description = "Project ID of the Shared VPC host project."
  value       = google_project.shared_vpc_host.project_id
}

output "shared_vpc_network_self_link" {
  description = "Self-link of the Shared VPC network, for service projects to attach subnets from."
  value       = google_compute_network.shared_vpc.self_link
}

output "subnet_self_links" {
  description = "Self-links of every subnet created in the Shared VPC, keyed by subnet name."
  value       = { for name, subnet in google_compute_subnetwork.subnets : name => subnet.self_link }
}

output "logging_project_id" {
  description = "Project ID of the centralized logging project."
  value       = google_project.logging.project_id
}

output "org_sink_writer_identity" {
  description = "Service identity the organization log sink writes as - needed if the destination's IAM ever needs to be re-verified."
  value       = google_logging_organization_sink.org_sink.writer_identity
}
