# BastionTier Subnet
resource "azurerm_subnet" "bastionsubnet" {
    name = var.bastion_subnet_name
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = var.bastion_subnet_address
}

# Network Security Group
resource "azurerm_network_security_group" "bastion_subnet_nsg" {
    name = "${azurerm_subnet.bastionsubnet.name}-nsg"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
}

# Network Security Group Association (associate subnet to network security group)
resource "azurerm_subnet_network_security_group_association" "bastion_subnet_nsg_association" {
    depends_on = [ azurerm_network_security_rule.bastion_nsg_inbound_rules ]
    subnet_id = azurerm_subnet.bastionsubnet.id
    network_security_group_id = azurerm_network_security_group.bastion_subnet_nsg.id
}

# NSG Inbound Rule for BastionTier Subnets
locals {
    bastion_inbound_ports_map = {
        "100" : "22",
        "110" : "3389"
    }
}

resource "azurerm_network_security_rule" "bastion_nsg_inbound_rules" {
    for_each = local.bastion_inbound_ports_map
    name = "rule-port-${each.value}"
    priority = each.key
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = each.value
    source_address_prefix = "*"
    destination_address_prefix = "*"
    resource_group_name = azurerm_resource_group.rg.name
    network_security_group_name = azurerm_network_security_group.bastion_subnet_nsg.name
}