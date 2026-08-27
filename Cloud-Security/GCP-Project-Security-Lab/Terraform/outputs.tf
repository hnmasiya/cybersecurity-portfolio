output "vm_name" {
  description = "Name of the deployed lab VM."
  value       = google_compute_instance.lab.name
}

output "vm_internal_ip" {
  description = "Internal IP of the lab VM. No external IP exists - connect via `gcloud compute ssh --tunnel-through-iap`."
  value       = google_compute_instance.lab.network_interface[0].network_ip
}

output "vm_service_account" {
  description = "Email of the least-privilege service account attached to the VM."
  value       = google_service_account.vm.email
}

output "network_self_link" {
  description = "Self-link of the lab's custom VPC."
  value       = google_compute_network.lab.self_link
}

output "bucket_url" {
  description = "gsutil URL of the lab's hardened storage bucket."
  value       = google_storage_bucket.lab.url
}

output "nat_gateway_name" {
  description = "Name of the Cloud NAT gateway the VM's outbound traffic goes through. Its auto-allocated external IP isn't a Terraform-visible attribute - check it with `gcloud compute routers nats describe` after apply."
  value       = google_compute_router_nat.nat.name
}
