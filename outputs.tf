# CHANGE: Updated to use azurerm_linux_web_app instead of module
output "frontend_url" {
  value       = "https://${azurerm_linux_web_app.frontend.default_hostname}"
  description = "URL of the frontend App Service"
}

# CHANGE: Updated to use azurerm_linux_web_app instead of module
output "backend_url" {
  value       = "https://${azurerm_linux_web_app.backend.default_hostname}"
  description = "URL of the backend App Service"
}

output "app_gateway_public_ip" {
  value       = module.app_gateway.public_ip_address
  description = "Public IP address of the Application Gateway"
}

output "mysql_server_fqdn" {
  value       = module.mysql.server_fqdn
  description = "FQDN of the MySQL server"
}