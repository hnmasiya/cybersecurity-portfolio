# Prepare Sysmon config for transfer to repository
# Run this on dc01-lab to prepare the config file for copying to your local machine

# Validate source file exists
$sourceFile = "C:\Users\hazvinei\sysmon-install\sysmonconfig-export.xml"
if (-not (Test-Path $sourceFile)) {
    Write-Host "ERROR: Source file not found at $sourceFile" -ForegroundColor Red
    exit 1
}

# Read and validate the configuration
Write-Host "Reading Sysmon configuration..." -ForegroundColor Green
[xml]$config = Get-Content $sourceFile

# Verify the fixes are applied
$imageLoadNodes = $config.SelectNodes("//ImageLoad/*[local-name()='Image' and contains(@condition, 'end with')]")
$rawAccessNodes = $config.SelectNodes("//RawAccessRead/*[local-name()='Image' and contains(@condition, 'end with')]")

Write-Host ""
Write-Host "=== Configuration Validation ===" -ForegroundColor Cyan
Write-Host "ImageLoad Image elements found: $($imageLoadNodes.Count)"
Write-Host "RawAccessRead Image elements found: $($rawAccessNodes.Count)"

# Check for broken elements
$brokenImageLoad = $config.SelectNodes("//ImageLoad/*[local-name()='TargetImage']")
$brokenRawAccess = $config.SelectNodes("//RawAccessRead/*[local-name()='TargetImage']")

if ($brokenImageLoad.Count -gt 0) {
    Write-Host "WARNING: Found $($brokenImageLoad.Count) broken TargetImage elements in ImageLoad" -ForegroundColor Yellow
}
if ($brokenRawAccess.Count -gt 0) {
    Write-Host "WARNING: Found $($brokenRawAccess.Count) broken TargetImage elements in RawAccessRead" -ForegroundColor Yellow
}

if ($brokenImageLoad.Count -eq 0 -and $brokenRawAccess.Count -eq 0) {
    Write-Host "✓ No broken elements detected - configuration is fixed!" -ForegroundColor Green
} else {
    Write-Host "✗ Configuration still contains broken elements" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=== File Ready for Transfer ===" -ForegroundColor Cyan
Write-Host "Source: $sourceFile"
Write-Host ""
Write-Host "Copy this file to your local machine using RDP file sharing:" -ForegroundColor Green
Write-Host "  1. Connect to dc01-lab via RDP with: mstsc /v:dc01-lab /drive:Z:C:\"
Write-Host "  2. Navigate to C:\Users\hazvinei\sysmon-install\ on dc01-lab"
Write-Host "  3. Copy sysmonconfig-export.xml to your local machine"
Write-Host "  4. Place in repository at:"
Write-Host "     Cloud-Security/Azure-Windows-Server-Lab/sysmon/sysmonconfig-export.xml"
Write-Host ""
Write-Host "Or use PowerShell to output the full config path:"
Write-Host "  $(Resolve-Path $sourceFile)"
