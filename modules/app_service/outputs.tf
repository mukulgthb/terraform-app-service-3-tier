output "default_hostname" {
  description = "The default hostname of the Linux Web App"
  value       = azurerm_linux_web_app.app.default_hostname
}

output "id" {
  description = "The ID of the Linux Web App"
  value       = azurerm_linux_web_app.app.id
}