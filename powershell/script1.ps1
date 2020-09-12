# return all methods and properties
$PSVERSIONTABLE | Get-Member

$PSVERSIONTABLE.GetType()
# IsPublic IsSerial Name                                     BaseType
#-------- -------- ----                                     --------
#True     True     Hashtable                                System.Object
