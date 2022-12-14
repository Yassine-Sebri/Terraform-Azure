# Create Public IP
resource "azurerm_public_ip" "web_lb_public_ip" {
    name = "web-lb-public-ip"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    allocation_method = "Static"
    sku = "Standard"
}

# Create Standard Load Balancer
resource "azurerm_lb" "web_lb" {
    name = "web-lb"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    sku = "Standard"
    frontend_ip_configuration {
      name = "web-lb-public-ip-1"
      public_ip_address_id = azurerm_public_ip.web_lb_public_ip.id
    }
}

# Create Backend Pool
resource "azurerm_lb_backend_address_pool" "web_lb_backend_address_pool" {
  name = "web-backend"
  loadbalancer_id = azurerm_lb.web_lb.id
}

# Create LB Probe
resource "azurerm_lb_probe" "web_lb_probe" {
    name = "tcp-probe"
    protocol = "Tcp"
    port = 80
    loadbalancer_id = azurerm_lb.web_lb.id
}

# Create LB Rule
resource "azurerm_lb_rule" "web_lb_rule_app1" {
  name = "web-app1-rule"
  protocol = "Tcp"
  frontend_port = 80
  backend_port = 80
  frontend_ip_configuration_name = azurerm_lb.web_lb.frontend_ip_configuration[0].name
  backend_address_pool_ids = [ azurerm_lb_backend_address_pool.web_lb_backend_address_pool.id ]
  probe_id = azurerm_lb_probe.web_lb_probe.id
  loadbalancer_id = azurerm_lb.web_lb.id
}