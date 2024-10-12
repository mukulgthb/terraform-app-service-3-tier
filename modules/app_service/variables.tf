variable "name" {
  description = "The name of the Linux Web App"
  type        = string
}

variable "location" {
  description = "The Azure region where the Linux Web App will be created"
  type        = string
  default = "West Europe"
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "service_plan_id" {
  description = "The ID of the App Service Plan"
  type        = string
}

variable "nodejs_version" {
  description = "The version of Node.js to use"
  type        = string
  default     = "14-lts"
}

variable "allowed_ip_range" {
  description = "The IP range allowed to access the Web App"
  type        = string
  default     = "0.0.0.0/0"
}

variable "app_settings" {
  description = "Additional app settings for the Web App"
  type        = map(string)
  default     = {}
}