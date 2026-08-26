<#
.SYNOPSIS
  Installs the Wazuh Agent on the deployed Domain Controller and points it
  at a Wazuh Manager reachable over Tailscale.

.DESCRIPTION
  Downloads the Windows Wazuh Agent MSI matching the target Manager's
  version and installs it silently, auto-enrolling against the given
  Manager address. Point WazuhManager at the Manager's Tailscale IP so
  this works without exposing the Manager's ports to the public internet
  - install and connect Tailscale first (see the lab README).

  Run this on the deployed VM (Cloud-Security/Azure-Windows-Server-Lab)
  as Administrator.

.PARAMETER WazuhManager
  IP or hostname of the Wazuh Manager to enroll against (its Tailscale IP).

.PARAMETER WazuhVersion
  Wazuh version to install. Must match (or be compatible with) the
  Manager's own version - check with `docker ps` on the Manager host.

.PARAMETER AgentName
  Name this agent registers under. Defaults to the local hostname.

.EXAMPLE
  .\Install-WazuhAgent.ps1 -WazuhManager "100.104.119.57" -WazuhVersion "4.14.7-1"
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$WazuhManager,

    [string]$WazuhVersion = "4.14.7-1",

    [string]$AgentName = $env:COMPUTERNAME
)

$work = "$env:USERPROFILE\wazuh-agent-install"
New-Item -ItemType Directory -Path $work -Force | Out-Null

$msiUrl = "https://packages.wazuh.com/4.x/windows/wazuh-agent-$WazuhVersion.msi"
$msiPath = "$work\wazuh-agent.msi"

Write-Host "[*] Downloading Wazuh Agent $WazuhVersion..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $msiUrl -OutFile $msiPath

Write-Host "[*] Installing Wazuh Agent, enrolling against $WazuhManager..." -ForegroundColor Cyan
Start-Process msiexec.exe -ArgumentList "/i `"$msiPath`" /q WAZUH_MANAGER=`"$WazuhManager`" WAZUH_AGENT_NAME=`"$AgentName`"" -Wait

Write-Host "[*] Starting Wazuh service..." -ForegroundColor Cyan
NET START WazuhSvc

Write-Host "[*] Verifying connection..." -ForegroundColor Cyan
Get-Content "C:\Program Files (x86)\ossec-agent\ossec.log" -Tail 15
