provider "azurerm" {
  features {}
}

locals {
  tags        = data.terraform_remote_state.core.outputs.tags
  k8s_version = data.terraform_remote_state.aks.outputs.k8s_version
}

resource "azurerm_resource_group" "aks_jump" {
  name     = "k8sauto-aks-jump"
  location = local.tags.region
  tags     = local.tags
}

resource "azurerm_network_security_group" "jump_box" {
  name                = "nsg-jumpbox-ssh"
  location            = local.tags.region
  resource_group_name = azurerm_resource_group.aks_jump.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = local.tags
}

resource "azurerm_network_interface_security_group_association" "vm_ssh" {
  network_interface_id      = azurerm_network_interface.vm.id
  network_security_group_id = azurerm_network_security_group.jump_box.id
}
