# In PowerShell, everything is an object. In technical terms, an object is an individual instance of a specific template, called a class. 

# return all methods and properties
$PSVERSIONTABLE | Get-Member

$PSVERSIONTABLE.GetType()
# IsPublic IsSerial Name                                     BaseType
#-------- -------- ----                                     --------
#True     True     Hashtable                                System.Object


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

