Connect-AzAccount

Get-AzSubscription

Set-AzContext -SubscriptionId ""

Get-AzADGroup -SearchString "developers"

Get-AzADGroup -DisplayName "developers" | Format-List -Property Id
