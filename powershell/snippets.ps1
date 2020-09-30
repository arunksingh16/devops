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
