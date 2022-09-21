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

# Virtual Network
variable "vnet_name" {
  type        = string
  default     = "vnet-default"
  description = "Virtual Network Name"
}

# Virtual Network Address Space
variable "vnet_address_space" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
  description = "Virtual Network Address Space"
}

# Web Subnet Name
variable "web_subnet_name" {
  type        = string
  default     = "websubnet"
  description = "Virtual Network Web Subnet Name"
}

# Web Subnet Address Space
variable "web_subnet_address" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "Virtual Network Web Subnet Address Space"
}

# App Subnet Name
variable "app_subnet_name" {
  type        = string
  default     = "appsubnet"
  description = "Virtual Network App Subnet Name"
}

# App Subnet Address Space
variable "app_subnet_address" {
  type        = list(string)
  default     = ["10.0.11.0/24"]
  description = "Virtual Network App Subnet Address Space"
}

# Database Subnet Name
variable "db_subnet_name" {
  type        = string
  default     = "dbsubnet"
  description = "Virtual Network Database Subnet Name"
}

# Database Subnet Address Space
variable "db_subnet_address" {
  type        = list(string)
  default     = ["10.0.21.0/24"]
  description = "Virtual Network Database Subnet Address Space"
}

# Bastion/Management Subnet Name
variable "bastion_subnet_name" {
  type        = string
  default     = "bastionsubnet"
  description = "Virtual Network Bastion Subnet Name"
}

# Bastion/Management Subnet Address Space
variable "bastion_subnet_address" {
  type        = list(string)
  default     = ["10.0.100.0/24"]
  description = "Virtual Network Bastion Subnet Address Space"
}