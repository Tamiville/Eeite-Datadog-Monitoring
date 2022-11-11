resource "azurerm_resource_group" "elite_general_resources" {
  name     = local.elite_general_resources
  location = var.location
}

resource "azurerm_network_interface" "labnic" {
  name                = join("-", [local.server, "lab", "nic"])
  location            = local.buildregion
  resource_group_name = azurerm_resource_group.elite_general_resources.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.application_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.labpip.id
  }
}

resource "azurerm_public_ip" "labpip" {
  name                = join("-", [local.server, "lab", "pip"])
  resource_group_name = azurerm_resource_group.elite_general_resources.name
  location            = local.buildregion
  allocation_method   = "Static"

  tags = local.common_tags
}


resource "azurerm_linux_virtual_machine" "Linuxvm" {
  name                = join("-", [local.server, "linux", "vm"])
  resource_group_name = azurerm_resource_group.elite_general_resources.name
  location            = local.buildregion
  size                = "Standard_DS1"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.labnic.id,
  ]

#   connection {
#     type        = "ssh"
#     user        = var.user
#     private_key = file(var.path_privatekey)
#     host        = self.public_ip_address
#   }

  admin_ssh_key {
    username   = "adminuser"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCryTP0UMENHKQhVtY+3slVfnGYaQ5ZNHiqILhdtbwqK3WUBva7lAPeFSRFIyC15rTm9C9vGg1Q+tvEpfTs7UVpDCOewkDHU9sOIgNg4TGd4hNXomCArgU5U7oKRlvGQOJZ8vZk5FLuqZ5A9637FhDcTSwJ/+DWXcEvacw3IHHImdAiJjmhTTxNqWCf70qpGRLKFQPsBszQMGRlHwse0xUv2lU1zwI8w9lJORA+7a/JMxgn0hNEKF9RpAUmQbLsldquISnU8jUVTYYWfgPYsZK8DD45iEA4Yb1TwVIezBwNrGYNJfZ54ijQ48bW+t88TEvw4lJNV9CUlBXqV+GI4zpqjBTcVS7pdsvaMOvnoWS5jA52IirD2YupnUj5J3tJPdT9vGtIbqHf20JtxvTR//BPi6xOemYfXEYRfBiPn2VWDApGgFV+oa0PJyNyHMwgRmHD2CgvappXN/FMoC+FV+qPyYPD1dYE2I2XccC/p0AJQE8zJaZaM3CKVa9Gqpztmnc= apple@Tamie-Emmanuel"
  }
  # provisioner "file" {
  #   source      = "./scripts/script.sh"
  #   destination = "/tmp/script.sh"
  # }
  # provisioner "local-exec" {
  #   command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ${var.user} -i '${self.public_ip_address},' --private-key ${var.path_privatekey} ansibleplaybooks/nginx.yml -vv"
  # }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    offer     = "0001-com-ubuntu-server-focal"
    publisher = "Canonical"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}
