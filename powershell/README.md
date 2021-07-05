### active directory module for powershell

```
# ACCOUNT PROPERTIES
Get-ADUser -Identity ACCNT_NAME -Properties *


# SEARCH
Get-ADUser -Filter "Name -eq 'ACCNT_NAME'" -SearchBase "DC=AppNC" -Properties "mail" -Server lds.Fabrikam.com:50000
Get-ADUser -Filter 'Name -like "ACCNT_NAME"'
Get-ADUser -Filter 'Name -like "ACCNT_NAME"' | Format-Table Name,SamAccountName -A

# specific details

Get-ADUser -Identity <ACCNT_NAME> -Properties * | ft Name,Enabled,whenChanged,PasswordLastSet,PasswordExpired,LockedOut,AccountLockoutTime
```


### Process Details


```
Get-Process | Select-Object -Property 'Id','StartTime','HandleCount' | Where-Object -FilterScript { $_.Id -eq "1"  } | Format-Table -AutoSize
```


### using covert-to-html
```
$Header = @"
<html>
<head>
<title>test</title>
<style type='text/css'>
table, th, td {
  border: 1px solid black;
  border-collapse: collapse;
}
th, td {
  padding: 5px;
}
</style>
</head>

<body>
$VFront
</body>
</html>
"@ 

'acc1','acc2' | Get-ADUser -Properties * | ConvertTo-Html -Head $Header -Property Name,Enabled,whenChanged,PasswordLastSet | Out-File -FilePath index.html

```


### working with trusted hosts on windows server

```
# listing it
Get-Item WSMan:\localhost\Client\TrustedHosts
(Get-Item WSMan:\localhost\Client\TrustedHosts).value
Set-Item WSMan:\localhost\Client\TrustedHosts -Value <servername> -Force -Concatenate
```


