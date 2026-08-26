<#
.SYNOPSIS
  Exports real Windows Security event log entries into the JSON schema that
  Active-Directory/Detection-Lab/Scripts/ad_security_event_analyzer.py expects.

.DESCRIPTION
  Run this on the deployed Domain Controller (after Harden-WindowsServer.ps1
  has applied the audit policy - without that, most of these event IDs are
  never generated in the first place).

  Field mapping per event type (Windows' real field names vary by event and
  don't match the analyzer's schema directly):

    4625/4771            TargetUserName            -> target_user
    4769                 TargetUserName             -> target_user
                          ServiceName                -> service_name
                          TicketEncryptionType        -> encryption_type
    4728/4732/4756        MemberName (user added)     -> target_user
                          TargetUserName (the GROUP) -> group_name
                          SubjectUserName (actor)     -> subject_user
    4720                 TargetUserName             -> target_user
                          SubjectUserName             -> subject_user
    4672                 SubjectUserName             -> target_user
                          (this event has no separate "target" field)
    1102                 SubjectUserName             -> subject_user

.PARAMETER OutputPath
  Where to write the JSON file. Defaults to .\security-events.json.

.PARAMETER MaxEvents
  Cap on how many raw events to pull (most recent first). Defaults to 500.

.EXAMPLE
  .\Export-SecurityEventLog.ps1 -OutputPath C:\Users\hazvinei\security-events.json
#>
[CmdletBinding()]
param(
    [string]$OutputPath = ".\security-events.json",
    [int]$MaxEvents = 500
)

$eventIds = 4625, 4771, 4769, 4728, 4732, 4756, 4720, 4672, 1102

function Get-EventFieldMap {
    param($XmlEvent)
    $map = @{}
    foreach ($data in $XmlEvent.Event.EventData.Data) {
        if ($data.Name) { $map[$data.Name] = $data.'#text' }
    }
    return $map
}

Write-Host "[*] Querying Security log for event IDs: $($eventIds -join ', ')..." -ForegroundColor Cyan

$rawEvents = Get-WinEvent -FilterHashtable @{ LogName = 'Security'; Id = $eventIds } -MaxEvents $MaxEvents -ErrorAction SilentlyContinue

if (-not $rawEvents) {
    Write-Warning "No matching Security events found yet. This is normal on a freshly hardened DC with little activity - RDP in a few more times, or intentionally fail a login 5+ times, then re-run."
    "[]" | Set-Content -Path $OutputPath -Encoding UTF8
    exit 0
}

$records = foreach ($evt in $rawEvents) {
    $xml = [xml]$evt.ToXml()
    $fields = Get-EventFieldMap -XmlEvent $xml
    $eventId = $evt.Id
    $timestamp = $evt.TimeCreated.ToString("o")

    switch ($eventId) {
        { $_ -in 4728, 4732, 4756 } {
            [PSCustomObject]@{
                event_id     = $eventId
                target_user  = $fields['MemberName']
                group_name   = $fields['TargetUserName']
                subject_user = $fields['SubjectUserName']
                timestamp    = $timestamp
            }
        }
        4769 {
            $encType = $fields['TicketEncryptionType']
            if ($encType -match '^\d+$') { $encType = "0x{0:x}" -f [int]$encType }
            [PSCustomObject]@{
                event_id        = $eventId
                target_user     = $fields['TargetUserName']
                service_name    = $fields['ServiceName']
                encryption_type = $encType
                timestamp       = $timestamp
            }
        }
        4672 {
            [PSCustomObject]@{
                event_id    = $eventId
                target_user = $fields['SubjectUserName']
                timestamp   = $timestamp
            }
        }
        1102 {
            [PSCustomObject]@{
                event_id     = $eventId
                subject_user = $fields['SubjectUserName']
                timestamp    = $timestamp
            }
        }
        default {
            [PSCustomObject]@{
                event_id     = $eventId
                target_user  = $fields['TargetUserName']
                subject_user = $fields['SubjectUserName']
                timestamp    = $timestamp
            }
        }
    }
}

$records | ConvertTo-Json -Depth 4 | Set-Content -Path $OutputPath -Encoding UTF8
Write-Host "[*] Wrote $($records.Count) events to $OutputPath" -ForegroundColor Green
