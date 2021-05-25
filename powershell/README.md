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
