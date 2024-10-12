resource "azurerm_mysql_flexible_server" "mysql" {
  name                   = var.name
  resource_group_name    = var.resource_group_name
  location               = var.location
  administrator_login    = var.admin_username
  administrator_password = var.admin_password

  sku_name = var.sku_name
  version  = "8.0.21"

  storage {
    size_gb           = 20
    iops              = 360
    auto_grow_enabled = true
  }

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  # Removed high_availability block for simplicity and to avoid potential issues

  maintenance_window {
    day_of_week  = 0
    start_hour   = 8
    start_minute = 0
  }

  lifecycle {
    ignore_changes = [
      high_availability
    ]
  }
}

resource "azurerm_mysql_flexible_database" "db" {
  name                = "${var.name}-db"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
}

resource "azurerm_mysql_flexible_server_configuration" "require_secure_transport" {
  name                = "require_secure_transport"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  value               = "ON"
}

resource "azurerm_mysql_flexible_server_configuration" "tls_version" {
  name                = "tls_version"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  value               = "TLSv1.2"
}

resource "azurerm_mysql_flexible_server_firewall_rule" "allow_azure_services" {
  name                = "AllowAzureServices"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_private_endpoint" "mysql_pe" {
  name                = "${var.name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.name}-privateserviceconnection"
    private_connection_resource_id = azurerm_mysql_flexible_server.mysql.id
    is_manual_connection           = false
    subresource_names              = ["mysqlServer"]
  }
}