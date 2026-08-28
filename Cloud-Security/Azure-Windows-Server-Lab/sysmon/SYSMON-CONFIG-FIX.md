# Sysmon Configuration Fix: STATUS_STACK_BUFFER_OVERRUN Resolution

## Summary

Fixed the SwiftOnSecurity Sysmon v74 configuration crash (STATUS_STACK_BUFFER_OVERRUN) by correcting invalid field names in Event 7 (ImageLoad) and Event 9 (RawAccessRead) filtering rules.

## Root Cause

The full Sysmon configuration from SwiftOnSecurity v74 contained two field name errors:

1. **Event 7 (ImageLoad)**: Used `<TargetImage>` instead of `<Image>`
   - ImageLoad events only support: `Image`, `ImageLoaded`, and event metadata fields
   - `TargetImage` is not a valid field for ImageLoad events

2. **Event 9 (RawAccessRead)**: Used `<TargetImage>` instead of `<Image>`
   - RawAccessRead events only support: `Image` and event metadata fields
   - `TargetImage` is not a valid field for RawAccessRead events

This caused Sysmon to attempt to match filters against non-existent fields, triggering a buffer overrun condition when processing events.

## The Fix

### Event 7 (ImageLoad)

**Before (BROKEN):**
```xml
<ImageLoad onmatch="include">
  <TargetImage condition="end with">lsass.exe</TargetImage>
</ImageLoad>
```

**After (FIXED):**
```xml
<ImageLoad onmatch="include">
  <Image condition="end with">lsass.exe</Image>
</ImageLoad>
```

### Event 9 (RawAccessRead)

**Before (BROKEN):**
```xml
<RawAccessRead onmatch="include">
  <TargetImage condition="end with">lsass.exe</TargetImage>
</RawAccessRead>
```

**After (FIXED):**
```xml
<RawAccessRead onmatch="include">
  <Image condition="end with">lsass.exe</Image>
</RawAccessRead>
```

## Validation

The fix was validated on dc01-lab by:

1. **Configuration validation**: Deployed config showed "Configuration file validated" and "Configuration updated" messages
2. **Attack simulations**: All 6 attack simulations triggered Wazuh alerts:
   - T1003 Credential Access (lsass.exe dump)
   - T1053/T1547 Persistence (Registry Run key)
   - T1059 Execution (PowerShell encoded command)
3. **Stability**: System ran for 30+ minutes without crashes

## File Location

- **Current location on dc01-lab**: `C:\Users\hazvinei\sysmon-install\sysmonconfig-export.xml`
- **Target location in repo**: `sysmonconfig-export.xml` (this directory)

## File Transfer Instructions

The fixed configuration file is currently located on dc01-lab. To transfer it to this repository:

### Option 1: Via RDP File Sharing (Easiest)

1. On your local machine, connect to dc01-lab via RDP
2. In RDP, map a local drive:
   - Start RDP with `/drive:Z:C:\` flag
   - Or use: `mstsc /v:dc01-lab /drive:Z:C:\`
3. Navigate to `C:\Users\hazvinei\sysmon-install\sysmonconfig-export.xml` on dc01-lab
4. Copy the file to `Z:\` (which maps to your local machine)
5. Transfer the file to your local cybersecurity-portfolio repo at this location
6. Commit and push to git

### Option 2: Via PowerShell (If SSH Available)

```powershell
# On dc01-lab via PowerShell:
Get-Content C:\Users\hazvinei\sysmon-install\sysmonconfig-export.xml | Out-File sysmonconfig-export.xml -Encoding UTF8 -Force

# Then use SCP or other transfer method to move the file
```

### Option 3: Via PowerShell Out-String

```powershell
# On dc01-lab:
$content = Get-Content C:\Users\hazvinei\sysmon-install\sysmonconfig-export.xml -Raw
[System.IO.File]::WriteAllText('C:\temp\sysmonconfig-export.xml', $content, [System.Text.Encoding]::UTF8)
```

## Next Steps

1. Transfer `sysmonconfig-export.xml` from dc01-lab
2. Place it in this directory: `Cloud-Security/Azure-Windows-Server-Lab/sysmon/sysmonconfig-export.xml`
3. Verify the fix is applied (search for `<Image condition="end with">lsass.exe</Image>` in both ImageLoad and RawAccessRead sections)
4. Commit with:
   ```bash
   git add Cloud-Security/Azure-Windows-Server-Lab/sysmon/sysmonconfig-export.xml
   git commit -m "Fix: Restore Sysmon full config with Events 7 & 9 field corrections

   - Event 7 (ImageLoad): TargetImage → Image
   - Event 9 (RawAccessRead): TargetImage → Image
   - Validated: All attack simulations trigger Wazuh alerts
   - Stability: 30+ min monitoring, no crashes
   - Config deployed on dc01-lab, ready for production"
   ```
5. Push to `claude/test-coverage-analysis-6tvybs` branch

## Reference Files

Test configurations demonstrating the fix are available in the scratchpad:
- `test-section3-imageload-FIXED.xml` - Shows corrected ImageLoad section
- `test-section4-rawaccess-FIXED.xml` - Shows corrected RawAccessRead section

## Related Documentation

- `SYSMON-INVESTIGATION-GUIDE.md` - Full investigation methodology
- `EXECUTION-PLAN.md` - Step-by-step testing plan
