# AppTier Subnet
resource "azurerm_subnet" "appsubnet" {
    name = var.app_subnet_name
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = var.app_subnet_address
}

# Network Security Group
resource "azurerm_network_security_group" "app_subnet_nsg" {
    name = "${azurerm_subnet.appsubnet.name}-nsg"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
}

# Network Security Group Association
resource "azurerm_subnet_network_security_group_association" "app_subnet_nsg_association" {
    depends_on = [ azurerm_network_security_rule.app_nsg_inbound_rules ]
    subnet_id = azurerm_subnet.appsubnet.id
    network_security_group_id = azurerm_network_security_group.app_subnet_nsg.id
}

# NSG Inbound Rule for AppTier Subnets
locals {
    app_inbound_ports_map = {
        "100" : "80",
        "110" : "443",
        "120" : "8080",
        "130" : "22"
    }
}

resource "azurerm_network_security_rule" "app_nsg_inbound_rules" {
    for_each = local.app_inbound_ports_map
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
    network_security_group_name = azurerm_network_security_group.app_subnet_nsg.name
}