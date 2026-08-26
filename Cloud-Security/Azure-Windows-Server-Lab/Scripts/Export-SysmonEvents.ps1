<#
.SYNOPSIS
  Exports real Sysmon and Security event log entries into the JSON
  schema that Endpoint-Security/Windows-Sysmon-Detection-Lab's
  detect() function expects.

.DESCRIPTION
  Run this on the deployed Domain Controller after Install-Sysmon.ps1
  has been applied and some activity has occurred.

  Field mapping (detect() checks image/parent_process as bare lowercase
  executable names, e.g. "powershell.exe", not full paths):

    Sysmon Event ID 1 (ProcessCreate)     Image (basename, lower)    -> image
                                           CommandLine                -> command_line
                                           ParentImage (basename,     -> parent_process
                                             lower)
    Sysmon Event ID 3 (NetworkConnect)    Image (basename, lower)    -> image
                                           DestinationPort             -> destination_port
    Security Event ID 4625 (failed logon) (no extra fields needed)   -> windows_event_id: 4625

.PARAMETER OutputPath
  Where to write the JSON file. Defaults to .\sysmon-events.json.

.PARAMETER MaxEvents
  Cap on how many raw events to pull per event type. Defaults to 200.

.EXAMPLE
  .\Export-SysmonEvents.ps1
#>
[CmdletBinding()]
param(
    [string]$OutputPath = ".\sysmon-events.json",
    [int]$MaxEvents = 200
)

function Get-EventFieldMap {
    param($XmlEvent)
    $map = @{}
    foreach ($data in $XmlEvent.Event.EventData.Data) {
        if ($data.Name) { $map[$data.Name] = $data.'#text' }
    }
    return $map
}

function Get-BaseName {
    param([string]$Path)
    if ([string]::IsNullOrEmpty($Path)) { return "" }
    return (Split-Path $Path -Leaf).ToLower()
}

$records = New-Object System.Collections.Generic.List[object]

Write-Host "[*] Reading Sysmon Process Create events (ID 1)..." -ForegroundColor Cyan
$procEvents = Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" -FilterXPath "*[System[EventID=1]]" -MaxEvents $MaxEvents -ErrorAction SilentlyContinue
foreach ($evt in $procEvents) {
    $xml = [xml]$evt.ToXml()
    $fields = Get-EventFieldMap -XmlEvent $xml
    $records.Add([PSCustomObject]@{
        windows_event_id = 1
        image            = Get-BaseName $fields['Image']
        command_line     = $fields['CommandLine']
        parent_process   = Get-BaseName $fields['ParentImage']
        timestamp        = $evt.TimeCreated.ToString("o")
    })
}

Write-Host "[*] Reading Sysmon Network Connect events (ID 3)..." -ForegroundColor Cyan
$netEvents = Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" -FilterXPath "*[System[EventID=3]]" -MaxEvents $MaxEvents -ErrorAction SilentlyContinue
foreach ($evt in $netEvents) {
    $xml = [xml]$evt.ToXml()
    $fields = Get-EventFieldMap -XmlEvent $xml
    $destPort = $fields['DestinationPort']
    $records.Add([PSCustomObject]@{
        windows_event_id = 3
        image            = Get-BaseName $fields['Image']
        destination_port = if ($destPort) { [int]$destPort } else { $null }
        timestamp        = $evt.TimeCreated.ToString("o")
    })
}

Write-Host "[*] Reading Security failed-logon events (ID 4625)..." -ForegroundColor Cyan
$logonEvents = Get-WinEvent -FilterHashtable @{ LogName = 'Security'; Id = 4625 } -MaxEvents $MaxEvents -ErrorAction SilentlyContinue
foreach ($evt in $logonEvents) {
    $records.Add([PSCustomObject]@{
        windows_event_id = 4625
        timestamp        = $evt.TimeCreated.ToString("o")
    })
}

if ($records.Count -eq 0) {
    Write-Warning "No events captured. Generate some activity and re-run."
    "[]" | Set-Content -Path $OutputPath -Encoding UTF8
    exit 0
}

$records | ConvertTo-Json -Depth 4 | Set-Content -Path $OutputPath -Encoding UTF8
Write-Host "[*] Wrote $($records.Count) events to $OutputPath" -ForegroundColor Green
Write-Host "[*] Breakdown: $($records | Group-Object windows_event_id | ForEach-Object { "ID $($_.Name): $($_.Count)" })" -ForegroundColor Green
