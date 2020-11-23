Connect-AzAccount

Get-AzSubscription

Set-AzContext -SubscriptionId ""

Get-AzADGroup -SearchString "developers"

Get-AzADGroup -DisplayName "developers" | Format-List -Property Id

# method 1 to fetch id 
Get-AzADGroup -DisplayName "developers"  | Select -ExpandProperty Id

# method 2 to fetch id
$ObjId = (Get-AzADGroup -DisplayName "developers").Id
Write-Host $ObjId
