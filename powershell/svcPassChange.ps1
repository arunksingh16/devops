# Script to update password for services in windows 
$Service = Get-WmiObject -Class Win32_Service -Filter  "StartName LIKE '%\\ACC_NAME' OR  StartName LIKE 'ACC_NAME@%'"
Write-Host "Services running with ACC_NAME and the status "
$Service | Select Name, StartName, State, Status
Write-Host "What are the methods available ? "
$Service | Get-Member -MemberType  Method 
#Get the secure string password 
$Password = Read-Host -Prompt "Enter password for $RunAsAccount" -AsSecureString
$Password
$BSTR = [system.runtime.interopservices.marshal]::SecureStringToBSTR($Password)
$Password = [system.runtime.interopservices.marshal]::PtrToStringAuto($BSTR)
$Password
$Service.Change($Null,$Null,$Null,$Null,$Null,$Null,$Null,$Password,$Null,$Null,$Null) 
Write-Host "Stopping Service"
$Service.StopService().ReturnValue
Write-Host "Starting Service"
$Service.StartService().ReturnValue

# https://docs.microsoft.com/en-us/windows/win32/cimwin32prov/startservice-method-in-class-win32-service
