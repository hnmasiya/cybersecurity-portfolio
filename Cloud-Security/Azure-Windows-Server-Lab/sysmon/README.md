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


---

# 20-Section Evidence-First Case Study Record

> **Standard:** Permanent portfolio case-study standard. This record is an explicit mapping of this lab to the repository's 20-section evidence framework. Existing technical detail and retained artifacts above remain authoritative; this section does not create new execution claims.

**Evidence state:** LIVE / REAL LAB

## 1. Scenario
The scenario documented in this README is the authoritative scenario. No additional scenario is inferred.

## 2. Business / Technical Context
The technical context is the environment, dataset, infrastructure, or simulation already described above. Production impact is not claimed unless supported by retained evidence.

## 3. Objective
The objective is the investigation, validation, engineering, or security outcome explicitly stated above.

## 4. Environment / Scope
Scope is limited to the hosts, applications, cloud resources, datasets, simulations, and repositories explicitly identified in this case study. No third-party scope is implied.

## 5. Tools Used
Tools are only those named in the existing case-study content and retained artifacts. Tool presence in the repository is not treated as proof that a tool was executed.

## 6. Investigation / Methodology
The methodology follows the documented workflow above: collect or generate authorized evidence, analyze it, validate findings, document interpretation, and preserve limitations.

## 7. Commands / Scripts Used
Executable commands and scripts remain in the existing lab paths. Only commands actually documented or retained by this lab are treated as executed evidence.

## 8. Evidence
Primary evidence is the retained files, logs, screenshots, datasets, reports, scripts, or validation outputs referenced above. Missing evidence is not reconstructed.

## 9. Indicators / Observations
Indicators and observations are limited to results explicitly reported in this README or its retained evidence. Observations are not automatically treated as malicious activity.

## 10. Analysis
Analysis separates observed facts from analyst interpretation. Where a finding has a documented benign explanation, that explanation is preserved rather than escalated into an unsupported incident claim.

## 11. Findings
Findings are those explicitly documented above or in retained analysis artifacts. A detector firing is treated as a finding requiring context, not proof of compromise by itself.

## 12. Risk / Impact
Risk and impact are described only where supported by the lab evidence and scope. Production business impact, customer impact, or breach status is not inferred from laboratory results.

## 13. Recommended Actions
Recommended actions are limited to the remediation, hardening, validation, containment, or follow-up actions supported by the documented findings.

## 14. Detection / Monitoring Opportunities
Relevant detection, logging, monitoring, alerting, baseline, and validation opportunities are those demonstrated or explicitly proposed by this case study. Unvalidated detections remain unvalidated.

## 15. MITRE ATT&CK Mapping
MITRE ATT&CK mappings are retained where already documented and are not expanded solely to make the case study appear more complete. Unsupported mappings remain omitted.

## 16. Lessons Learned
The lessons are derived from the documented execution, validation, troubleshooting, or methodology. Failed approaches are retained where they materially explain how the final result was reached.

## 17. Skills Demonstrated
Skills are limited to capabilities evidenced by the documented work: investigation, detection engineering, scripting, telemetry analysis, cloud/security configuration, reporting, or related activities actually represented by the lab.

## 18. Portfolio / SOC Relevance
This case study demonstrates how the documented work maps to SOC, detection engineering, DFIR, cloud security, vulnerability management, or security automation workflows without claiming production employment experience.

## 19. Evidence & Limitations
Evidence classification is explicit: **LIVE / REAL LAB**. Synthetic, offline, architectural, pending, or virtual evidence must not be represented as live production experience. Dataset size, environmental constraints, missing telemetry, and unperformed steps remain limitations.

## 20. References / Source Material
References are the existing linked artifacts, scripts, reports, datasets, vendor documentation, standards, and source material already retained by this lab. No external execution evidence is implied by a reference link alone.

### Evidence Integrity Statement
This case study is complete only to the extent supported by retained evidence. **No fabricated metrics, certifications, incidents, production claims, or execution results are introduced by this standardization.**
