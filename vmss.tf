# Custom Data
locals {
  custom_data = <<CUSTOM_DATA
#!/bin/bash
sudo apt install -y apache2
sudo service apache2 start
CUSTOM_DATA
}

# Create a Virtual Machine Scale Set
resource "azurerm_linux_virtual_machine_scale_set" "web-vmss" {
  name = "web-vmss"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  sku = "Standard_B1s"
  admin_username = "webadmin"
  admin_ssh_key {
    username = "webadmin"
    public_key = file("${path.module}/ssh-keys/azure_key.pub")
  }
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  custom_data = base64encode(local.custom_data)
  network_interface {
    name = "web-vmss-nic"
    primary = true
    ip_configuration {
        name = "internal"
        primary = true
        subnet_id = azurerm_subnet.websubnet.id
        load_balancer_backend_address_pool_ids = [ azurerm_lb_backend_address_pool.web_lb_backend_address_pool.id ]
    }
  }
}