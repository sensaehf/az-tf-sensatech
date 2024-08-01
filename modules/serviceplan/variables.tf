variable "resource_group_name" {
  type = string
  description = "Resource group name for all module resources."
}

variable "location" {
  type = string
  description = "Location of the App service plan"
}

variable "name" {
  type = string
  description = "Name of the App service Plan, must be globally unique"
}

variable "os_type" {
  type = string
  description = "OS type Windows or Linux"
  default = "Windows"
}

variable "sku_name" {
  type = string
  description = "Sku Type e.g. Y1"
  default = "Y1"
}