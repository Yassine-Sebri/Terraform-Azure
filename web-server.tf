# Create NIC
resource "azurerm_network_interface" "web_linuxvm_nic" {
    count = var.web_linux_vm_instance_count
    name = "web-linuxvm-nic-${count.index}"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    ip_configuration {
        name = "web-linuxvm-ip-1"
        subnet_id = azurerm_subnet.websubnet.id
        private_ip_address_allocation = "Dynamic"
    }
}

# Custom Data
locals {
  custom_data = <<CUSTOM_DATA
#!/bin/bash
sudo apt install -y apache2
sudo service apache2 start
CUSTOM_DATA
}

# Create Linux VM
resource "azurerm_linux_virtual_machine" "web_linuxvm" {
    count = var.web_linux_vm_instance_count
    name = "web-linuxvm-${count.index}"
    computer_name = "web-linux-vm${count.index}" # Hostname (optional)
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    size = "Standard_B1s"
    admin_username = "webadmin"
    network_interface_ids = [ element(azurerm_network_interface.web_linuxvm_nic[*].id, count.index) ]
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
}