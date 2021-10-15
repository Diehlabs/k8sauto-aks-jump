resource "local_file" "ansible_inventory" {
  filename = "${path.module}/ansible/inventory.yml"
  content = templatefile("${path.module}/ansible/inventory.yml.tpl", {
    user_id          = "adminuser"
    host_ip          = azurerm_public_ip.vm.ip_address
    k8s_version      = local.k8s_version
    kubeconf_content = sensitive(base64encode(data.terraform_remote_state.aks.outputs.kube_admin_config))
    #content_base64 = module.paks.kube_config
  })
}

resource "local_file" "rsa_key" {
  filename          = "${path.module}/ansible/rsa.key"
  sensitive_content = data.terraform_remote_state.core.outputs.ssh_key.private_key_pem
  file_permission   = "0600"
}

# resource "null_resource" "ansible" {
#   depends_on = [
#     local_file.ansible_inventory,
#     local_file.rsa_key,
#   ]
#   provisioner "local-exec" {
#     command = "ansible-playbook ${path.module}/ansible/setup.yml -i ${path.module}/ansible/inventory.yml --private-key ${path.module}/ansible/rsa.key"
#   }
# }
