<#
.SYNOPSIS
  Promotes a fresh Windows Server VM into a new single-forest, single-domain
  Active Directory Domain Controller.

.DESCRIPTION
  Run this manually on the VM after Terraform has provisioned it (RDP in, or
  use `az vm run-command invoke`). Deliberately not wired into Terraform as a
  provisioner: AD DS promotion requires a reboot mid-install, which
  provisioners handle unreliably, so this is a documented manual step instead
  of a fragile automated one.

.PARAMETER DomainName
  Fully qualified domain name for the new forest, e.g. "lab.local".

.PARAMETER SafeModeAdministratorPassword
  DSRM password for the new domain, as a SecureString. Prompted for
  interactively if not supplied — never pass this as plain text on the
  command line or hardcode it here.

.EXAMPLE
  .\Configure-DomainController.ps1 -DomainName "lab.local"
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$DomainName,

    [Parameter(Mandatory = $false)]
    [SecureString]$SafeModeAdministratorPassword
)

if (-not $SafeModeAdministratorPassword) {
    $SafeModeAdministratorPassword = Read-Host -AsSecureString -Prompt "DSRM (Safe Mode) administrator password"
}

Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

Import-Module ADDSDeployment

Install-ADDSForest `
    -DomainName $DomainName `
    -SafeModeAdministratorPassword $SafeModeAdministratorPassword `
    -InstallDns:$true `
    -DomainMode "WinThreshold" `
    -ForestMode "WinThreshold" `
    -DatabasePath "C:\Windows\NTDS" `
    -LogPath "C:\Windows\NTDS" `
    -SysvolPath "C:\Windows\SYSVOL" `
    -NoRebootOnCompletion:$false `
    -Force:$true

# The VM reboots automatically to complete promotion. After it comes back
# up, run Harden-WindowsServer.ps1 to apply the security/audit baseline.
