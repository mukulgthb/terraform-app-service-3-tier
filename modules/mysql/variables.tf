variable "name" {
  description = "Name of the MySQL flexible server"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the MySQL server will be deployed"
  type        = string
}

variable "location" {
  description = "The Azure region where the MySQL server will be created"
  type        = string
  default     = "West Europe"
}

variable "admin_username" {
  description = "The administrator username for the MySQL server"
  type        = string
}

variable "admin_password" {
  description = "The administrator password for the MySQL server"
  type        = string
  sensitive   = true
}

variable "subnet_id" {
  description = "The ID of the subnet for the private endpoint"
  type        = string
}

variable "sku_name" {
  description = "The SKU name for the MySQL Flexible Server"
  type        = string
  default     = "GP_Standard_D2ds_v4"
}