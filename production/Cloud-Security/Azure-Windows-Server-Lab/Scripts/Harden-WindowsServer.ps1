<#
.SYNOPSIS
  Baseline security hardening for the lab's Windows Server VM, run after
  initial provisioning (and after AD DS promotion, if this box is the DC).

.DESCRIPTION
  Applies a small, CIS-benchmark-aligned baseline:
    - Enables the Advanced Audit Policy subcategories needed to actually
      generate the Windows Security event IDs (4624/4625/4769/4771/4728/
      4732/4756) that Active-Directory/Detection-Lab/Scripts/
      ad_security_event_analyzer.py looks for. Without this step the
      default audit policy on a fresh Windows Server install is too sparse
      to produce most of those events.
    - Disables SMBv1 (MS17-010 / EternalBlue exposure).
    - Confirms Windows Defender real-time protection is on.
    - Confirms the Windows Firewall is enabled on all profiles (defense in
      depth alongside the NSG already restricting inbound access).

  Idempotent — safe to re-run.

.EXAMPLE
  .\Harden-WindowsServer.ps1
#>
[CmdletBinding()]
param()

function Write-Step {
    param([string]$Message)
    Write-Host "[*] $Message" -ForegroundColor Cyan
}

Write-Step "Enabling audit policy for account logon / account management / logon-logoff..."
auditpol /set /subcategory:"Credential Validation" /success:enable /failure:enable | Out-Null
auditpol /set /subcategory:"Kerberos Authentication Service" /success:enable /failure:enable | Out-Null
auditpol /set /subcategory:"Kerberos Service Ticket Operations" /success:enable /failure:enable | Out-Null
auditpol /set /subcategory:"Logon" /success:enable /failure:enable | Out-Null
auditpol /set /subcategory:"Logoff" /success:enable /failure:enable | Out-Null
auditpol /set /subcategory:"Security Group Management" /success:enable /failure:enable | Out-Null
auditpol /set /subcategory:"User Account Management" /success:enable /failure:enable | Out-Null

Write-Step "Disabling SMBv1..."
Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart -ErrorAction SilentlyContinue | Out-Null
Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force -ErrorAction SilentlyContinue

Write-Step "Confirming Windows Defender real-time protection..."
Set-MpPreference -DisableRealtimeMonitoring $false -ErrorAction SilentlyContinue

Write-Step "Confirming Windows Firewall is enabled on all profiles..."
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True

Write-Step "Hardening baseline applied. Current audit policy:"
auditpol /get /category:* | Select-String "Credential Validation|Kerberos|Logon|Logoff|Security Group Management|User Account Management"
