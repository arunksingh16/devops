# Single SMB Share Detail Script
param(
    [Parameter(Mandatory=$true)]
    [string]$ShareName
)

Write-Host "=== DETAILED ANALYSIS FOR SHARE: $ShareName ===" -ForegroundColor Cyan
Write-Host ""

try {
    # Get basic share information
    $share = Get-SmbShare -Name $ShareName -ErrorAction Stop
    
    Write-Host "1. BASIC SHARE INFORMATION" -ForegroundColor Yellow
    Write-Host "   Share Name: $($share.Name)"
    Write-Host "   Path: $($share.Path)"
    Write-Host "   Description: $($share.Description)"
    Write-Host "   Share Type: $($share.ShareType)"
    Write-Host "   Allow Maximum Users: $($share.AllowMaximum)"
    Write-Host "   Maximum Users: $($share.MaximumUsers)"
    Write-Host "   Creation Time: $($share.CreationTime)"
    Write-Host "   Last Modified: $($share.LastModified)"
    Write-Host ""
    
    # Get SMB share permissions
    Write-Host "2. SMB SHARE PERMISSIONS" -ForegroundColor Yellow
    $sharePermissions = Get-SmbShareAccess -Name $ShareName -ErrorAction Stop
    if ($sharePermissions) {
        $sharePermissions | Format-Table AccountName, AccessRight, AccessControlType -AutoSize
    } else {
        Write-Host "   No specific share permissions found (using default)"
    }
    Write-Host ""
    
    # Get NTFS permissions if path exists
    Write-Host "3. NTFS PERMISSIONS (Folder Level)" -ForegroundColor Yellow
    if ($share.Path -and (Test-Path $share.Path)) {
        try {
            $acl = Get-Acl $share.Path
            $ntfsPerms = $acl.Access | Sort-Object IdentityReference, FileSystemRights
            
            if ($ntfsPerms) {
                $ntfsPerms | ForEach-Object {
                    Write-Host "   $($_.IdentityReference) - $($_.FileSystemRights) - $($_.AccessControlType)"
                }
            } else {
                Write-Host "   No NTFS permissions found"
            }
        } catch {
            Write-Host "   Error reading NTFS permissions: $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        Write-Host "   Path not accessible or doesn't exist: $($share.Path)"
    }
    Write-Host ""
    
    # Get share properties and advanced settings
    Write-Host "4. ADVANCED SHARE SETTINGS" -ForegroundColor Yellow
    try {
        $shareProps = Get-SmbShare -Name $ShareName | Get-Member -MemberType Property | 
                     Where-Object { $_.Name -notin @('Name', 'Path', 'Description', 'ShareType', 'AllowMaximum', 'MaximumUsers', 'CreationTime', 'LastModified') }
        
        foreach ($prop in $shareProps) {
            $value = $share.$($prop.Name)
            if ($value -ne $null) {
                Write-Host "   $($prop.Name): $value"
            }
        }
    } catch {
        Write-Host "   Error reading advanced properties: $($_.Exception.Message)" -ForegroundColor Red
    }
    Write-Host ""
    
    # Check if share is accessible
    Write-Host "5. SHARE ACCESSIBILITY TEST" -ForegroundColor Yellow
    try {
        $testPath = "\\$env:COMPUTERNAME\$ShareName"
        if (Test-Path $testPath) {
            Write-Host "   Share is accessible via: $testPath" -ForegroundColor Green
        } else {
            Write-Host "   Share path not accessible via: $testPath" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "   Error testing share accessibility: $($_.Exception.Message)" -ForegroundColor Red
    }
    Write-Host ""
    
    # Get registry information for the share
    Write-Host "6. REGISTRY INFORMATION" -ForegroundColor Yellow
    try {
        $regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Shares\$ShareName"
        if (Test-Path $regPath) {
            $regValues = Get-ItemProperty -Path $regPath
            $regValues | Get-Member -MemberType NoteProperty | ForEach-Object {
                if ($_.Name -notin @('PSPath', 'PSParentPath', 'PSChildName', 'PSProvider')) {
                    $value = $regValues.$($_.Name)
                    Write-Host "   $($_.Name): $value"
                }
            }
        } else {
            Write-Host "   No registry entry found for this share"
        }
    } catch {
        Write-Host "   Error reading registry: $($_.Exception.Message)" -ForegroundColor Red
    }
    Write-Host ""
    
    # Export detailed information to file
    Write-Host "7. EXPORTING DETAILS TO FILE" -ForegroundColor Yellow
    
    # Create export data object
    $exportData = [PSCustomObject]@{
        ShareName = $share.Name
        Path = $share.Path
        Description = $share.Description
        ShareType = $share.ShareType
        AllowMaximum = $share.AllowMaximum
        MaximumUsers = $share.MaximumUsers
        CreationTime = $share.CreationTime
        LastModified = $share.LastModified
        SMBPermissions = ($sharePermissions | ForEach-Object { "$($_.AccountName) - $($_.AccessRight) - $($_.AccessControlType)" }) -join "; "
        NTFSPermissions = if ($share.Path -and (Test-Path $share.Path)) { 
            try { 
                $acl = Get-Acl $share.Path
                ($acl.Access | ForEach-Object { "$($_.IdentityReference) - $($_.FileSystemRights) - $($_.AccessControlType)" }) -join "; "
            } catch { "Error reading NTFS permissions" }
        } else { "Path not accessible" }
        RegistryPath = $regPath
        ExportDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    }
    
    $fileName = "Share_${ShareName}_Details_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
    $exportData | Export-Csv -Path $fileName -NoTypeInformation
    Write-Host "   Details exported to: $fileName" -ForegroundColor Green
    
    # Also export to JSON for easy replication
    $jsonFile = "Share_${ShareName}_Details_$(Get-Date -Format 'yyyyMMdd_HHmmss').json"
    $exportData | ConvertTo-Json -Depth 10 | Out-File $jsonFile
    Write-Host "   JSON export saved to: $jsonFile" -ForegroundColor Green
    
} catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Make sure the share name '$ShareName' exists and you have permission to access it." -ForegroundColor Yellow
}
