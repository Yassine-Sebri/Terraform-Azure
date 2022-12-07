# Create Public IP
resource "azurerm_public_ip" "bastion_linuxvm_public_ip" {
    name = "bastion-linuxvm-public-ip"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    allocation_method = "Static"
    sku = "Standard"
    domain_name_label = "bastion-vm"
}

# Create NIC
resource "azurerm_network_interface" "bastion_linuxvm_nic" {
    name = "bastion-linuxvm-nic"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    ip_configuration {
        name = "bastion-linuxvm-ip"
        subnet_id = azurerm_subnet.bastionsubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.bastion_linuxvm_public_ip.id
    }
}

# Create Linux VM
resource "azurerm_linux_virtual_machine" "bastion_linuxvm" {
    name = "bastion-linuxvm"
    computer_name = "bastion-linux-vm" # Hostname (optional)
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    size = "Standard_B1s"
    admin_username = "bastionadmin"
    network_interface_ids = [ azurerm_network_interface.bastion_linuxvm_nic.id ]
    admin_ssh_key {
        username = "bastionadmin"
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
}

resource "null_resource" "null_copy_ssh_key_to_bastion" {
    depends_on = [azurerm_linux_virtual_machine.bastion_linuxvm]
    connection {
        type = "ssh"
        host = azurerm_linux_virtual_machine.bastion_linuxvm.public_ip_address
        user = azurerm_linux_virtual_machine.bastion_linuxvm.admin_username
        private_key = file("${path.module}/ssh-keys/azure_key")
    }
    provisioner "file" {
        source = "ssh-keys/azure_key"
        destination = "/tmp/azure_key"
    }
    provisioner "remote-exec" {
      inline = ["sudo chmod 400 /tmp/azure_key"]
    }
}