resource "azurerm_linux_web_app" "app" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.service_plan_id

  site_config {
    application_stack {
      node_version = var.nodejs_version
    }
    always_on      = true
    ftps_state     = "FtpsOnly"
    http2_enabled  = true

    ip_restriction {
      ip_address = var.allowed_ip_range
      priority   = 100
      action     = "Allow"
    }
  }

  app_settings = merge(var.app_settings, {
    "WEBSITE_NODE_DEFAULT_VERSION" = var.nodejs_version
    "WEBSITE_RUN_FROM_PACKAGE"     = "1"
  })

  identity {
    type = "SystemAssigned"
  }

  logs {
    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 35
      }
    }
  }
}