output "jump_box_ip" {
  value = azurerm_public_ip.vm.ip_address
}

output "ansible_inventory" {
  value     = local_file.ansible_inventory.content
  sensitive = true
}
