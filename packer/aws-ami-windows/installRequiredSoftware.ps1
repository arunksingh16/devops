
# Script to configure Windows instance during AMI creation
Write-Host "Starting Windows AMI configuration..." 
Write-Host "PACKER_BUILD_NAME is:" $Env:PACKER_BUILD_NAME

# Create a directory for installations
Write-Host "Creating installation directory..."
New-Item -Path "C:\installations" -ItemType Directory -Force

# Download and install AWS CLI
Write-Host "Installing AWS CLI..."
$awsCliUrl = "https://awscli.amazonaws.com/AWSCLIV2.msi"
$awsCliInstaller = "C:\installations\AWSCLIV2.msi"

# Download the AWS CLI installer
Invoke-WebRequest -Uri $awsCliUrl -OutFile $awsCliInstaller

# Install AWS CLI silently
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i", $awsCliInstaller, "/qn" -Wait

# Verify installation
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
Write-Host "AWS CLI version:"
aws --version


# add another admin user named serviceaccount
New-LocalUser -Name "serviceaccount" -Password (ConvertTo-SecureString "$Env:PASSWORD" -AsPlainText -Force) -FullName "Service Account" -Description "Service Account for Packer Builds"
Add-LocalGroupMember -Group "Administrators" -Member "serviceaccount"
# Set the service account password to never expire
wmic useraccount where "name='serviceaccount'" set PasswordExpires=FALSE
# Set the service account to not require password change at next logon
Set-LocalUser -Name "serviceaccount" -PasswordNeverExpires $true
# list all local users
Get-LocalUser | Select-Object Name, Enabled, PasswordNeverExpires, UserMustChangePassword, LastLogon
Write-host "Local users created successfully."

Write-host "Creating a new partition and formatting it..."
$partition = Get-Disk | Where-Object PartitionStyle -Eq 'RAW' | Initialize-Disk -PartitionStyle MBR -PassThru |
  New-Partition -UseMaximumSize -AssignDriveLetter

$driveLetter = ($partition | Get-Partition | Get-Volume).DriveLetter

$partition | Format-Volume -FileSystem NTFS -NewFileSystemLabel "Data" -Confirm:$false

# Use this to assign letters explicitly
if ($driveLetter -and $driveLetter -ne 'D') {
    Set-Partition -DriveLetter $driveLetter -NewDriveLetter D
}
Write-host "Partition created and formatted successfully."
