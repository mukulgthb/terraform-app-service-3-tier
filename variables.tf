variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "qops"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "qops-rg"
}

variable "location" {
  description = "Azure region to deploy resources"
  type        = string
  default     = "West Europe "
}

variable "db_admin_username" {
  description = "MySQL admin username"
  type        = string
  default     = "mysqladmin"
}

variable "db_admin_password" {
  description = "MySQL admin password"
  type        = string
  sensitive   = true
  default = "admin@123"
}