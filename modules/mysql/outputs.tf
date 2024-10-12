output "server_name" {
  description = "The name of the MySQL flexible server"
  value       = azurerm_mysql_flexible_server.mysql.name
}

output "server_fqdn" {
  description = "The fully qualified domain name of the MySQL server"
  value       = azurerm_mysql_flexible_server.mysql.fqdn
}

output "connection_string" {
  description = "The connection string for the MySQL database (without password)"
  value       = "mysql://${azurerm_mysql_flexible_server.mysql.administrator_login}@${azurerm_mysql_flexible_server.mysql.fqdn}:3306/${azurerm_mysql_flexible_database.db.name}"
  sensitive   = true
}

output "administrator_login" {
  description = "The administrator login for the MySQL server"
  value       = azurerm_mysql_flexible_server.mysql.administrator_login
}

output "database_name" {
  description = "The name of the MySQL database"
  value       = azurerm_mysql_flexible_database.db.name
}

output "private_endpoint_ip" {
  description = "The private IP address of the MySQL server private endpoint"
  value       = azurerm_private_endpoint.mysql_pe.private_service_connection[0].private_ip_address
}