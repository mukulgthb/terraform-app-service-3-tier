# Specify required providers
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Configure the Azure provider
provider "azurerm" {
  features {}
  subscription_id = "8bf9a8dc-8ee1-4364-ba97-77e92d38ee92"
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create subnets
resource "azurerm_subnet" "frontend" {
  name                 = "${var.prefix}-frontend-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "backend" {
  name                 = "${var.prefix}-backend-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create Application Gateway
module "app_gateway" {
  source              = "./modules/app_gateway"
  name                = "${var.prefix}-appgw"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.frontend.id
  frontend_port       = 80
  backend_address_pool = [
    azurerm_linux_web_app.frontend.default_hostname
  ]
}

# Create App Service Plan
resource "azurerm_service_plan" "plan" {
  name                = "${var.prefix}-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}

# Create Frontend App Service
resource "azurerm_linux_web_app" "frontend" {
  name                = "${var.prefix}-frontend"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    application_stack {
      node_version = "14-lts"
    }
  }

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "14-lts"
    "BACKEND_URL"                  = "https://${azurerm_linux_web_app.backend.default_hostname}"
  }
}

# Create Backend App Service
resource "azurerm_linux_web_app" "backend" {
  name                = "${var.prefix}-backend"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    application_stack {
      node_version = "14-lts"
    }
  }

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "14-lts"
    "DATABASE_URL"                 = module.mysql.connection_string
  }
}

# Create MySQL Database
module "mysql" {
  source              = "./modules/mysql"
  name                = "${var.prefix}-mysql"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  admin_username      = var.db_admin_username
  admin_password      = var.db_admin_password
  subnet_id           = azurerm_subnet.backend.id
  sku_name            = "GP_Standard_D2ds_v4"
}