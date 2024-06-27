resource "azurerm_resource_group" "DigicertTest" {
  location = "northeurope"
  name     = "DigicertTest"
}
resource "azurerm_key_vault" "DigicertTest_kv" {
  enable_rbac_authorization = true
  location                  = "northeurope"
  name                      = "TommisMadDigicert"
  resource_group_name       = "DigicertTest"
  sku_name                  = "standard"
  tenant_id                 = "dcc5e94c-873d-4593-940a-ba26b1970342"
  depends_on = [
    azurerm_resource_group.DigicertTest,
  ]
}
resource "azurerm_service_plan" "DigicertTest_sp" {
  location            = "norwayeast"
  name                = "ASP-DigicertTest-8c5e"
  os_type             = "Linux"
  resource_group_name = "DigicertTest"
  sku_name            = "B1"
  depends_on = [
    azurerm_resource_group.DigicertTest,
  ]
}
resource "azurerm_linux_web_app" "DigicertTest_wa" {
  location            = "norwayeast"
  name                = "tommismadcertdashboard"
  resource_group_name = "DigicertTest"
  service_plan_id     = "/subscriptions/3846f4f0-152c-49d5-9779-9998df4a2c0c/resourceGroups/DigicertTest/providers/Microsoft.Web/serverFarms/ASP-DigicertTest-8c5e"
  auth_settings_v2 {
    auth_enabled           = true
    default_provider       = "azureactivedirectory"
    require_authentication = true
    active_directory_v2 {
      allowed_audiences          = ["api://87398946-33e4-4b6f-8daf-9f59c58d3d69"]
      client_id                  = "87398946-33e4-4b6f-8daf-9f59c58d3d69"
      client_secret_setting_name = "MICROSOFT_PROVIDER_AUTHENTICATION_SECRET"
      tenant_auth_endpoint       = "https://sts.windows.net/dcc5e94c-873d-4593-940a-ba26b1970342/v2.0"
    }
    login {
      logout_endpoint     = "/.auth/logout"
      token_store_enabled = true
    }
  }
  site_config {
    ftps_state                        = "FtpsOnly"
    http2_enabled                     = true
    ip_restriction_default_action     = "Allow"
    scm_ip_restriction_default_action = "Allow"
  }
  sticky_settings {
    app_setting_names = ["MICROSOFT_PROVIDER_AUTHENTICATION_SECRET"]
  }
  depends_on = [
    azurerm_service_plan.DigicertTest_sp,
  ]
}
