# Azure PowerShell 


## AzureRM 

AzureRM module used to support Azure operations on powershell
Azure PowerShell AzureRM module, which is now in bugfix-only maintenance mode.
AzureRM module is not supported for macOS or Linux. To use Azure PowerShell cmdlets on these platforms, Install the Az module.
https://docs.microsoft.com/en-us/powershell/azure/azurerm/overview?view=azurermps-6.13.0

## PowerShell Imp Commands

```
# Version
$PSVersionTable.PSVersion
Get-Alais
Get-Command
Get-Module -ListAvailable
$env.PSModulePath
```

## AZ Module

https://github.com/Azure/azure-powershell

```
# Get all of the Azure subscriptions in your current Azure tenant
Get-AzSubscription

# Get all of the Azure subscriptions in a specific Azure tenant
Get-AzSubscription -TenantId $TenantId

# Gets the Azure PowerShell context for the current PowerShell session
Get-AzContext

# Lists all available Azure PowerShell contexts in the current PowerShell session
Get-AzContext -ListAvailable
```
