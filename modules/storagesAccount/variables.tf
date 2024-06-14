variable "resource_group_name" {
  type = string
  description = "Resource group name for all module resources."
}

variable "location" {
  type = string
  description = "Region that the resource should be placed"
  default = "westeurope"
}


variable "access_tier" {
  type = string
  description = "Accres tiers: default:Hot, Cool"
  default = "Hot"

  validation {
    condition = contains(["Hot","Cool"], var.access_tier)
    error_message = "The access_tier must be one of these Hot, Cool"
  }
}

variable "name" {
  type = string
  description = "Name of the storage account, must be globally unique"
}

variable "account_tier" {
  type = string
  description = "Storage tier for the account Standard or Premium. Default: Standard"
  default = "Standard"

  validation {
        condition = contains(["Standard","Premium"], var.account_tier)
        error_message = "The account_tier must be Standard or Premium"
  }
}

variable "account_replication_type" {
  type = string
  description = "Type of redudancy: Default:LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS"
  default = "LRS"
  validation {
        condition = contains(["LRS", "GRS", "RAGRS","ZRS","GZRS","RAGZRS"], var.account_replication_type)
        error_message = "The account_tier must be Standard or Premium"
  }
}