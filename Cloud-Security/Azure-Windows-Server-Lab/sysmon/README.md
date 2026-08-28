# Sysmon Full Configuration - Fixed & Validated

## Status: Ready for File Transfer

The Sysmon configuration crash (STATUS_STACK_BUFFER_OVERRUN) has been **analyzed**, **fixed**, and **validated** on dc01-lab. All that remains is transferring the corrected configuration file to this repository.

## What Was Fixed

**Root Cause**: Events 7 (ImageLoad) and 9 (RawAccessRead) used invalid field names `<TargetImage>` instead of `<Image>`.

**Solution**: Corrected field names in both event types to match Sysmon's XML schema requirements.

**Impact**: 
- ✅ Configuration loads without crashing
- ✅ Sysmon service starts successfully
- ✅ All 6 attack simulations trigger Wazuh alerts (T1003, T1053/T1547, T1059)
- ✅ System stability verified for 30+ minutes

## Files in This Directory

| File | Purpose |
|------|---------|
| `SYSMON-CONFIG-FIX.md` | Complete documentation of the issue, fix, and validation |
| `prepare-config-transfer.ps1` | PowerShell script to prepare/verify config on dc01-lab |
| `verify-config.sh` | Bash script to verify fixes are applied after transfer |
| `sysmonconfig-export.xml` | **[TO BE TRANSFERRED]** The fixed Sysmon configuration |

## How to Complete This Task

### Step 1: Transfer the Fixed Configuration

The fixed configuration is currently located on dc01-lab at:
```
C:\Users\hazvinei\sysmon-install\sysmonconfig-export.xml
```

**Transfer using RDP File Sharing (Recommended):**

```powershell
# On your local machine, start RDP with drive mapping:
mstsc /v:dc01-lab /drive:Z:C:\

# Once connected, navigate to:
# C:\Users\hazvinei\sysmon-install\sysmonconfig-export.xml
# 
# Copy the file to your local machine's Downloads or a temporary location
```

**Alternative - Copy via Command Line:**

If you have RDP connected, copy the file to a shared location first:
```powershell
# On dc01-lab via PowerShell:
Copy-Item "C:\Users\hazvinei\sysmon-install\sysmonconfig-export.xml" "C:\temp\sysmonconfig-export.xml"
```

### Step 2: Place the File in This Repository

Once you have the file on your local machine:

```bash
# Copy the fixed configuration to this directory
cp /path/to/sysmonconfig-export.xml ./Cloud-Security/Azure-Windows-Server-Lab/sysmon/

# Verify the fixes are applied
./Cloud-Security/Azure-Windows-Server-Lab/sysmon/verify-config.sh
```

### Step 3: Commit and Push

```bash
# On the main branch
git add Cloud-Security/Azure-Windows-Server-Lab/sysmon/sysmonconfig-export.xml

git commit -m "Restore Sysmon full config: fix Events 7 & 9 field name validation crash

- Root cause: ImageLoad and RawAccessRead sections used 'TargetImage' instead of 'Image'
- Fix: Corrected field names to match Sysmon XML schema
- Event 7 (ImageLoad): TargetImage → Image  
- Event 9 (RawAccessRead): TargetImage → Image
- Validation: Deployed on dc01-lab, all attack simulations trigger Wazuh alerts
- Stability: Ran 30+ minutes without crashes
- Closes: STATUS_STACK_BUFFER_OVERRUN crash on full config load"

git push -u origin main
```

## Current Configuration Status

| Item | Status | Notes |
|------|--------|-------|
| Issue identified | ✅ Complete | Events 7 & 9 field name errors |
| Root cause analyzed | ✅ Complete | Schema validation failure |
| Fix designed | ✅ Complete | Change TargetImage → Image |
| Fix applied to config | ✅ Complete | Applied on dc01-lab |
| Configuration validated | ✅ Complete | No crash, proper load messages |
| Attack simulations tested | ✅ Complete | All 6 MITRE techniques trigger alerts |
| System stability tested | ✅ Complete | 30+ min monitoring, no crashes |
| Configuration transferred | ⏳ **IN PROGRESS** | Awaiting file transfer from dc01-lab |
| Repository commit | ⏳ **PENDING** | Blocked on file transfer |
| Lab marked complete | ⏳ **PENDING** | Blocked on commit |

## Test Evidence

The fixes were validated using test configurations before applying to the full config:

- `test-section3-imageload-FIXED.xml` - Demonstrates corrected Event 7 
- `test-section4-rawaccess-FIXED.xml` - Demonstrates corrected Event 9

These are available in the investigation scratchpad and show the exact changes applied.

## Verification Commands

Once the file is in place, verify the fixes:

```bash
# Bash verification script
./Cloud-Security/Azure-Windows-Server-Lab/sysmon/verify-config.sh

# Or manually verify:
grep -A2 '<ImageLoad onmatch="include">' sysmonconfig-export.xml
grep -A2 '<RawAccessRead onmatch="include">' sysmonconfig-export.xml

# Both should show <Image condition="end with">lsass.exe</Image>
# NOT <TargetImage>
```

## Documentation

For detailed information about the investigation and fix, see:
- `SYSMON-CONFIG-FIX.md` - Complete technical documentation
- Scratchpad: `SYSMON-INVESTIGATION-GUIDE.md` - Investigation methodology
- Scratchpad: `EXECUTION-PLAN.md` - Testing and validation plan

## Questions?

Refer to `SYSMON-CONFIG-FIX.md` for complete documentation of:
- Root cause analysis
- Technical details of the fix
- Validation methodology
- File transfer instructions
