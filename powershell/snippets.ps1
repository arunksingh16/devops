# In PowerShell, everything is an object. In technical terms, an object is an individual instance of a specific template, called a class. 

# return all methods and properties
$PSVERSIONTABLE | Get-Member

$PSVERSIONTABLE.GetType()
# IsPublic IsSerial Name                                     BaseType
#-------- -------- ----                                     --------
#True     True     Hashtable                                System.Object


# groups attached with userid
(Get-ADUser userName –Properties MemberOf).MemberOf


# list old alias 
Get-Alias

# variables
Set-Variable -Name color -Value blue
Get-Variable -Name color
$color = 'blue'
$color

#when prev command ran successfully
$LASTEXITCODE

#data type
$num = 1
$num.GetType().name

# LIST ALL CMD AVAILABLE
Get-Command 


# .NET version
(Get-ItemProperty "HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full").Release -ge 460798

# ENV VARIABLE USR SCOPED
[System.Environment]::SetEnvironmentVariable('TEMP','c:\temp',[System.EnvironmentVariableTarget]::User)
# ENV VARIABLE SYSTEM SCOPED
[System.Environment]::SetEnvironmentVariable('TMP','c:\temp',[System.EnvironmentVariableTarget]::Machine)

# list 
Get-ChildItem Env:TEMP

# deleting a service
$service = Get-WmiObject -Class Win32_Service -Filter "Name='Tomcat8'"
$service.delete()
sc delete "Service Name"


# execution policy and scope
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
Get-ExecutionPolicy -List

# port to process mapping
Get-Process -Id (Get-NetTCPConnection -LocalPort 8081).OwningProcess
netstat -ano | findStr "8080"
tasklist /fi "pid eq 2216"
netstat -aon | findstr '[port_number]'

# stop process
$P = Get-Process -Id (Get-NetTCPConnection -LocalPort 3000).OwningProcess; Stop-Process $P.Id

# test path
Test-Path

# find port mapping
Get-Process -Id (Get-NetTCPConnection -LocalPort 80).OwningProcess
