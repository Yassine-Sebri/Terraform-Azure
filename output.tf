output "public_ip" {
  value       = azurerm_public_ip.web_linuxvm_public_ip.ip_address
  description = "Public IP of the Web Server"
  depends_on  = [azurerm_public_ip.web_linuxvm_public_ip]
}