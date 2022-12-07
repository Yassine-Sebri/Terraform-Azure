# Create Public IP
resource "azurerm_public_ip" "web_linuxvm_public_ip" {
    name = "web-linuxvm-public-ip"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    allocation_method = "Static"
    sku = "Standard"
    domain_name_label = "web-vm"
}

# Create NIC
resource "azurerm_network_interface" "web_linuxvm_nic" {
    name = "web-linuxvm-nic"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    ip_configuration {
        name = "web-linuxvm-ip-1"
        subnet_id = azurerm_subnet.websubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.web_linuxvm_public_ip.id
    }
}

# Create Linux VM
resource "azurerm_linux_virtual_machine" "web_linuxvm" {
    name = "web-linuxvm"
    computer_name = "web-linux-vm" # Hostname (optional)
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    size = "Standard_B1s"
    admin_username = "webadmin"
    network_interface_ids = [ azurerm_network_interface.web_linuxvm_nic.id ]
    admin_ssh_key {
        username = "webadmin"
        public_key = file("${path.module}/ssh-keys/web_server.pub")
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