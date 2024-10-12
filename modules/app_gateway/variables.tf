variable "name" {
  description = "Name of the Application Gateway"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region to deploy resources"
  type        = string
  default = "West Europe"
}

variable "subnet_id" {
  description = "ID of the subnet for the Application Gateway"
  type        = string
}

variable "frontend_port" {
  description = "Frontend port for the Application Gateway"
  type        = number
  default     = 80
}

variable "backend_address_pool" {
  description = "List of backend addresses"
  type        = list(string)
}