<powershell>
Write-Host "Setting up password for Admin."

# Set a static password
net user ${winrm_username} ${winrm_password}
wmic useraccount where "name='${winrm_username}'" set PasswordExpires=FALSE

# Enable WinRM
winrm quickconfig -quiet
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="2048"}'

Set-Item -Path WSMan:\localhost\Service\AllowUnencrypted -Value $true

# Open firewall
New-NetFirewallRule -DisplayName "WinRM Port" -Direction Inbound -Protocol TCP -LocalPort 5985 -Action Allow
New-NetFirewallRule -DisplayName "WinRM SSL Port" -Direction Inbound -Protocol TCP -LocalPort 5986 -Action Allow
</powershell>
