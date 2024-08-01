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
  description = "Name of the Azure Function APP, must be globally unique"
}


variable "storage_account_name" {
  type = string
  description = "Name of the  the function app uses"
}

variable "storage_account_access_key" {
  type = string
  description = "Name of the storageaccount, used for permission on the storage account"
}

variable "service_plan_id" {
    type = string
    description = "ID of the service app plan that the function runs on"
}


