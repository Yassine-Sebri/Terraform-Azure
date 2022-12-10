# Create AutoScale Profiles
resource "azurerm_monitor_autoscale_setting" "web_vmss_autoscale" {
  name = "web-vmss-autoscale-profile"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  target_resource_id = azurerm_linux_virtual_machine_scale_set.web-vmss.id
  notification {
    email {
        send_to_subscription_administrator = true
    }
  }
  profile {
    name = "default"
    capacity {
        default = 2
        minimum = 2
        maximum = 6
    }
    rule {
        scale_action {
          direction = "Increase"
          type = "ChangeCount"
          value = 1
          cooldown = "PT5M"
        }
        metric_trigger {
          metric_name = "Percentage CPU"
          metric_resource_id = azurerm_linux_virtual_machine_scale_set.web-vmss.id
          metric_namespace = "microsoft.compute/virtualmachinescalesets"
          time_grain = "PT1M"
          statistic = "Average"
          time_window = "PT5M"
          time_aggregation = "Average"
          operator = "GreaterThan"
          threshold = 75
        }
    }
    rule {
        scale_action {
          direction = "Decrease"
          type = "ChangeCount"
          value = 1
          cooldown = "PT5M"
        }
        metric_trigger {
          metric_name = "Percentage CPU"
          metric_resource_id = azurerm_linux_virtual_machine_scale_set.web-vmss.id
          metric_namespace = "microsoft.compute/virtualmachinescalesets"
          time_grain = "PT1M"
          statistic = "Average"
          time_window = "PT5M"
          time_aggregation = "Average"
          operator = "GreaterThan"
          threshold = 25
        }
    }
  }
}