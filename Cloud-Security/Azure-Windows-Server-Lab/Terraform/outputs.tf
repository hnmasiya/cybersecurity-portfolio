output "vm_name" {
  description = "Name of the deployed Windows Server VM."
  value       = azurerm_windows_virtual_machine.lab.name
}

output "public_ip_address" {
  description = "Public IP address to RDP into (only reachable from admin_source_ip)."
  value       = azurerm_public_ip.lab.ip_address
}

output "resource_group_name" {
  description = "Resource group holding all lab resources, for teardown."
  value       = azurerm_resource_group.lab.name
}
