resource "azurerm_resource_group" "res-0" {
  location = "northeurope"
  name     = "DSC_Test"
    tags = {
    TerraformStatus = "Managed"
  }
}
resource "azurerm_automation_account" "res-1" {
  location            = "northeurope"
  name                = "DSC-Sensatest"
  resource_group_name = azurerm_resource_group.res-0.name
  sku_name            = "Basic"
  identity {
    type = "SystemAssigned"
  }

}
resource "azurerm_automation_dsc_nodeconfiguration" "res-117" {
  automation_account_name = azurerm_automation_account.res-1.name
  name                    = "SetWebServers.DSC-tester"
  resource_group_name     = azurerm_resource_group.res-0.name
  content_embedded        = "configuration test {}"
  
}
resource "azurerm_automation_dsc_configuration" "res-118" {
  automation_account_name = azurerm_automation_account.res-1.name
  content_embedded        = <<EOT
  configuration DNSSetServer{
    Import-DscResource -ModuleName NetworkingDsc
    Import-DscResource -ModuleName PsDesiredStateConfiguration
    Node 'DSC-tester'{
      # The first resource block ensures that the Web-Server (IIS) feature is enabled.     
      WindowsFeature WebServer {
        Ensure = "Present"
        Name   = "Web-Server"
        } 
      DnsServerAddress SetDnsServers {
        Address = "8.8.8.8", "1.1.1.1"  # Specify your DNS server addresses here
        InterfaceAlias = "Ethernet"  # Replace with the actual network interface alias
        AddressFamily = "IPv4"
        Validate = $true
        }
      }
    } 
  EOT
  location                = "northeurope"
  name                    = "DNSSetServer"
  resource_group_name     = azurerm_resource_group.res-0.name

}
resource "azurerm_automation_dsc_configuration" "res-119" {
  automation_account_name = azurerm_automation_account.res-1.name
  content_embedded        = "configuration SetWebServers\r\n{\r\n    Import-DscResource -ModuleName NetworkingDsc\r\n    Import-DscResource -ModuleName PsDesiredStateConfiguration\r\n    Node 'DSC-tester'\r\n    {\r\n        # The first resource block ensures that the Web-Server (IIS) feature is enabled.\r\n        WindowsFeature WebServer {\r\n            Ensure = \"Present\"\r\n                Name   = \"Web-Server\"\r\n            }\r\n\r\n        DnsServerAddress SetDnsServers {\r\n            Address = \"8.8.8.8\", \"1.1.1.1\"  # Specify your DNS server addresses here\r\n            InterfaceAlias = \"Ethernet\"  # Replace with the actual network interface alias\r\n            AddressFamily = \"IPv4\"\r\n            Validate = $true\r\n        }\r\n\r\n        \r\n    }\r\n}"
  location                = "northeurope"
  name                    = "SetWebServers"
  resource_group_name     = azurerm_resource_group.res-0.name

}
resource "azurerm_automation_runbook" "res-120" {
  automation_account_name = azurerm_automation_account.res-1.name
  content                 = "<#\n    .DESCRIPTION\n        An example runbook which gets all the ARM resources using the Managed Identity\n\n    .NOTES\n        AUTHOR: Azure Automation Team\n        LASTEDIT: Oct 26, 2021\n#>\n\n\"Please enable appropriate RBAC permissions to the system identity of this automation account. Otherwise, the runbook may fail...\"\n\ntry\n{\n    \"Logging in to Azure...\"\n    Connect-AzAccount -Identity\n}\ncatch {\n    Write-Error -Message $_.Exception\n    throw $_.Exception\n}\n\n#Get all ARM resources from all resource groups\n$ResourceGroups = Get-AzResourceGroup\n\nforeach ($ResourceGroup in $ResourceGroups)\n{    \n    Write-Output (\"Showing resources in resource group \" + $ResourceGroup.ResourceGroupName)\n    $Resources = Get-AzResource -ResourceGroupName $ResourceGroup.ResourceGroupName\n    foreach ($Resource in $Resources)\n    {\n        Write-Output ($Resource.Name + \" of type \" +  $Resource.ResourceType)\n    }\n    Write-Output (\"\")\n}"
  description             = " An example runbook which gets all the ARM resources using the Managed Identity."
  location                = "northeurope"
  log_progress            = false
  log_verbose             = false
  name                    = "AzureAutomationTutorialWithIdentity"
  resource_group_name     = azurerm_resource_group.res-0.name
  runbook_type            = "PowerShell"

}
resource "azurerm_windows_virtual_machine" "res-122" {
  admin_password        = "Hunter-!2"
  admin_username        = "dscTest"
  eviction_policy       = "Deallocate"
  location              = "northeurope"
  name                  = "DSC-tester"
  network_interface_ids = ["/subscriptions/3846f4f0-152c-49d5-9779-9998df4a2c0c/resourceGroups/DSC_Test/providers/Microsoft.Network/networkInterfaces/dsc-tester179_z1"]
  priority              = "Spot"
  resource_group_name   = azurerm_resource_group.res-0.name
  secure_boot_enabled   = true
  size                  = "Standard_D2s_v3"
  vtpm_enabled          = true
  zone                  = "1"
  additional_capabilities {
  }
  boot_diagnostics {
  }
  identity {
    type = "SystemAssigned"
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
  source_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
  depends_on = [
    azurerm_network_interface.res-125,
  ]
}
resource "azurerm_virtual_machine_extension" "res-123" {
  auto_upgrade_minor_version = true
  automatic_upgrade_enabled  = true
  name                       = "AzurePolicyforWindows"
  publisher                  = "Microsoft.GuestConfiguration"
  settings                   = jsonencode({})
  type                       = "ConfigurationforWindows"
  type_handler_version       = "1.1"
  virtual_machine_id         = "/subscriptions/3846f4f0-152c-49d5-9779-9998df4a2c0c/resourceGroups/DSC_Test/providers/Microsoft.Compute/virtualMachines/DSC-tester"
  depends_on = [
    azurerm_windows_virtual_machine.res-122,
  ]
}
resource "azurerm_virtual_machine_extension" "res-124" {
  auto_upgrade_minor_version = true
  name                       = "Microsoft.Powershell.DSC"
  publisher                  = "Microsoft.Powershell"
  settings = jsonencode({
    configurationArguments = {
      ActionAfterReboot              = "continueConfiguration"
      AllowModuleOverwrite           = true
      ConfigurationMode              = "applyAndMonitor"
      ConfigurationModeFrequencyMins = 15
      NodeConfigurationName          = "DNSSetServer.DSC-tester"
      RebootNodeIfNeeded             = true
      RefreshFrequencyMins           = 30
      RegistrationUrl                = "https://fbb97202-a87c-4052-8d99-ad6ebad822a2.agentsvc.ne.azure-automation.net/accounts/fbb97202-a87c-4052-8d99-ad6ebad822a2"
    }
  })
  tags = {
    AutomationAccountARMID = "/subscriptions/3846f4f0-152c-49d5-9779-9998df4a2c0c/resourceGroups/DSC_Test/providers/Microsoft.Automation/automationAccounts/DSC-Sensatest"
  }
  type                 = "DSC"
  type_handler_version = "2.76"
  virtual_machine_id   = "/subscriptions/3846f4f0-152c-49d5-9779-9998df4a2c0c/resourceGroups/DSC_Test/providers/Microsoft.Compute/virtualMachines/DSC-tester"
  depends_on = [
    azurerm_automation_account.res-1,
    azurerm_windows_virtual_machine.res-122,
  ]
}
resource "azurerm_network_interface" "res-125" {
  enable_accelerated_networking = true
  location                      = "northeurope"
  name                          = "dsc-tester179_z1"
  resource_group_name           = azurerm_resource_group.res-0.name
  ip_configuration {

    name                          = "ipconfig1"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "/subscriptions/3846f4f0-152c-49d5-9779-9998df4a2c0c/resourceGroups/DSC_Test/providers/Microsoft.Network/publicIPAddresses/DSC-tester-ip"
    subnet_id                     = "/subscriptions/3846f4f0-152c-49d5-9779-9998df4a2c0c/resourceGroups/DSC_Test/providers/Microsoft.Network/virtualNetworks/DSC-tester-vnet/subnets/default"
  }
  depends_on = [
    azurerm_public_ip.res-128,
    azurerm_subnet.res-130,
  ]
}
resource "azurerm_network_interface_security_group_association" "res-126" {
  network_interface_id      = "/subscriptions/3846f4f0-152c-49d5-9779-9998df4a2c0c/resourceGroups/DSC_Test/providers/Microsoft.Network/networkInterfaces/dsc-tester179_z1"
  network_security_group_id = "/subscriptions/3846f4f0-152c-49d5-9779-9998df4a2c0c/resourceGroups/DSC_Test/providers/Microsoft.Network/networkSecurityGroups/DSC-tester-nsg"
  depends_on = [
    azurerm_network_interface.res-125,
    azurerm_network_security_group.res-127,
  ]
}
resource "azurerm_network_security_group" "res-127" {
  location            = "northeurope"
  name                = "DSC-tester-nsg"
  resource_group_name = azurerm_resource_group.res-0.name

}
resource "azurerm_public_ip" "res-128" {
  allocation_method   = "Static"
  location            = "northeurope"
  name                = "DSC-tester-ip"
  resource_group_name = azurerm_resource_group.res-0.name
  sku                 = "Standard"
  zones               = ["1"]

}
resource "azurerm_virtual_network" "res-129" {
  address_space       = ["10.0.0.0/16"]
  location            = "northeurope"
  name                = "DSC-tester-vnet"
  resource_group_name = azurerm_resource_group.res-0.name

}
resource "azurerm_subnet" "res-130" {
  address_prefixes     = ["10.0.0.0/24"]
  name                 = "default"
  resource_group_name  = azurerm_resource_group.res-0.name
  virtual_network_name = "DSC-tester-vnet"
  depends_on = [
    azurerm_virtual_network.res-129,
  ]
}
