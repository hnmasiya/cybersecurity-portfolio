<#
.SYNOPSIS
  Installs Sysmon on the deployed Domain Controller with the
  SwiftOnSecurity community-standard configuration.

.DESCRIPTION
  Sysmon logs nothing useful with its default settings - it needs an
  explicit rule configuration to actually capture process creation,
  network connections, and other events worth analyzing. This script
  downloads Sysmon itself from Microsoft's official Sysinternals site
  and a widely-used community config (SwiftOnSecurity/sysmon-config)
  before installing.

  Run this on the deployed VM (Cloud-Security/Azure-Windows-Server-Lab)
  as Administrator.

.EXAMPLE
  .\Install-Sysmon.ps1
#>
[CmdletBinding()]
param()

$work = "$env:USERPROFILE\sysmon-install"
New-Item -ItemType Directory -Path $work -Force | Out-Null

Write-Host "[*] Downloading Sysmon from Microsoft Sysinternals..." -ForegroundColor Cyan
Invoke-WebRequest -Uri "https://download.sysinternals.com/files/Sysmon.zip" -OutFile "$work\Sysmon.zip"
Expand-Archive -Path "$work\Sysmon.zip" -DestinationPath "$work\Sysmon" -Force

Write-Host "[*] Downloading SwiftOnSecurity community Sysmon config..." -ForegroundColor Cyan
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/SwiftOnSecurity/sysmon-config/master/sysmonconfig-export.xml" -OutFile "$work\sysmonconfig-export.xml"

Write-Host "[*] Installing Sysmon service..." -ForegroundColor Cyan
& "$work\Sysmon\Sysmon64.exe" -accepteula -i "$work\sysmonconfig-export.xml"

Write-Host "[*] Verifying Sysmon service is running..." -ForegroundColor Cyan
Get-Service Sysmon64 | Format-List Name, Status, StartType
