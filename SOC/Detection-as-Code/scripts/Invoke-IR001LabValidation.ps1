[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$OutputDirectory
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# This exercise is intentionally local-only. It launches a benign encoded
# PowerShell command, creates a temp marker, and attempts loopback TCP only.
# Review output locally; never commit raw event evidence to a public repository.

$resolvedOutput = [System.IO.Path]::GetFullPath($OutputDirectory)
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
if ($resolvedOutput.StartsWith($repoRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "Choose an output directory outside the repository working tree."
}
New-Item -ItemType Directory -Path $resolvedOutput -Force | Out-Null

$startUtc = [DateTime]::UtcNow
$markerPath = Join-Path $env:TEMP ("ir001-lab-marker-{0}.txt" -f ([Guid]::NewGuid().ToString("N")))
$runId = [Guid]::NewGuid().ToString()
$payload = "Write-Output 'IR001-LAB-BENIGN-$runId'"
$encoded = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($payload))
$childOutput = Join-Path $resolvedOutput "child-output.txt"

try {
    $process = Start-Process -FilePath "powershell.exe" -ArgumentList @(
        "-NoProfile", "-NonInteractive", "-EncodedCommand", $encoded
    ) -Wait -PassThru -RedirectStandardOutput $childOutput
    Set-Content -LiteralPath $markerPath -Value "IR001-LAB-BENIGN $runId" -Encoding UTF8

    # Loopback only; a refused connection is acceptable. No external target is used.
    $client = [System.Net.Sockets.TcpClient]::new()
    try {
        $pending = $client.BeginConnect("127.0.0.1", 9, $null, $null)
        [void]$pending.AsyncWaitHandle.WaitOne(1000)
        try { $client.EndConnect($pending) } catch [System.Net.Sockets.SocketException] { }
    } finally {
        $client.Dispose()
    }

    Start-Sleep -Seconds 2
    $endUtc = [DateTime]::UtcNow
    $logs = @(
        @{ LogName = "Microsoft-Windows-Sysmon/Operational"; Ids = @(1, 3, 11) },
        @{ LogName = "Security"; Ids = @(4688) }
    )
    $captured = @()
    $logStatus = @()

    foreach ($spec in $logs) {
        try {
            $records = Get-WinEvent -FilterHashtable @{
                LogName = $spec.LogName
                StartTime = $startUtc.ToLocalTime().AddMinutes(-1)
                EndTime = $endUtc.ToLocalTime().AddMinutes(1)
                Id = $spec.Ids
            } -ErrorAction Stop
            foreach ($record in $records) {
                $xml = [xml]$record.ToXml()
                $data = @{}
                foreach ($item in $xml.Event.EventData.Data) {
                    if ($null -ne $item.Name) { $data[[string]$item.Name] = [string]$item.'#text' }
                }
                $captured += [pscustomobject]@{
                    source = $spec.LogName
                    event_id = [int]$record.Id
                    timestamp_utc = $record.TimeCreated.ToUniversalTime().ToString("o")
                    computer = [string]$record.MachineName
                    record_id = [long]$record.RecordId
                    provider = [string]$record.ProviderName
                    event_data = $data
                }
            }
            $logStatus += [pscustomobject]@{ log_name = $spec.LogName; available = $true; records_returned = @($records).Count; error = $null }
        } catch {
            $logStatus += [pscustomobject]@{ log_name = $spec.LogName; available = $false; records_returned = 0; error = $_.Exception.Message }
        }
    }

    $bundle = [ordered]@{
        schema_version = 1
        test_id = "IR-001-LAB"
        evidence_type = "authorized-lab-telemetry"
        run_id = $runId
        started_utc = $startUtc.ToString("o")
        ended_utc = $endUtc.ToString("o")
        host = [Environment]::MachineName
        child_exit_code = $process.ExitCode
        marker_path = $markerPath
        loopback_target = "127.0.0.1:9"
        log_status = $logStatus
        events = @($captured | Sort-Object timestamp_utc, event_id)
        note = "Review and sanitize locally before any sharing. Event coverage depends on host audit and Sysmon configuration."
    }
    $jsonPath = Join-Path $resolvedOutput "ir001-lab-evidence.json"
    $bundle | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $jsonPath -Encoding UTF8
    $hash = Get-FileHash -LiteralPath $jsonPath -Algorithm SHA256
    [pscustomobject]@{
        test_id = "IR-001-LAB"
        evidence_file = [System.IO.Path]::GetFileName($jsonPath)
        sha256 = $hash.Hash.ToLowerInvariant()
        created_utc = [DateTime]::UtcNow.ToString("o")
        evidence_type = "authorized-lab-telemetry"
    } | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $resolvedOutput "manifest.json") -Encoding UTF8

    Write-Host "Evidence bundle written locally: $jsonPath"
    Write-Host "Review log_status and events; missing event IDs may indicate collection gaps."
    Write-Host "The evidence is not automatically sanitized. Do not commit raw evidence to a public repository."
} finally {
    if (Test-Path -LiteralPath $markerPath) {
        Write-Host "Temporary marker remains for review: $markerPath"
        Write-Host "Remove it after validation if no longer required."
    }
}
