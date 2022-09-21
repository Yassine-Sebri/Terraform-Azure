output "virtual_network_name" {
  value       = azurerm_virtual_network.vnet.name
  description = "Virtual Network Name"
  depends_on  = [azurerm_virtual_network.vnet]
}

output "virtual_network_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "Virtual Network ID"
  depends_on  = [azurerm_virtual_network.vnet]
}