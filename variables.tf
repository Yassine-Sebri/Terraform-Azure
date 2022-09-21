# Azure Resource Group Name
variable "resource_group_name" {
  type        = string
  default     = "rg-default"
  description = "Resource Group Name"
}

# Azure Resource Group Location
variable "resource_group_location" {
  type        = string
  default     = "eastus2"
  description = "Region in which Azure resources are to be created"
}