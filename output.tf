output "lb_public_ip" {
  value = azurerm_public_ip.web_lb_public_ip.ip_address
  description = "Public IP of the Load Balancer"
  depends_on = [ azurerm_public_ip.web_lb_public_ip ]
}

output "bastion_host_public_ip" {
  value       = azurerm_public_ip.bastion_linuxvm_public_ip.ip_address
  description = "Public IP of the Bastion Host"
  depends_on  = [azurerm_public_ip.bastion_linuxvm_public_ip]
}

