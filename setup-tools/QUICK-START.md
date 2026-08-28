# Quick Start: Portfolio Complete Setup

## 30-Second Setup

```bash
cd /path/to/cybersecurity-portfolio
bash setup-tools/portfolio-complete-setup.sh
```

Done! Check the log:
```bash
tail setup_*.log
```

## What Just Happened?

Your portfolio now includes enterprise SOC documentation across 4 major security domains:

✅ **SOC/Microsoft-Sentinel-KQL/** — Sentinel detection methodology with KQL queries  
✅ **SOC/Endpoint-Detection/** — EDR investigation patterns from your Azure lab  
✅ **SOC/MITRE-ATT&CK/** — Attack technique coverage matrix  
✅ **Cloud-Security/Unified-Cloud-Detection/** — Multi-cloud detection scenarios  
✅ **Automation/SOC-Automation/** — Alert enrichment and playbook workflow  

Plus real evidence linking to your existing labs:
- 23/23 labs (already complete)
- Azure Windows Server lab with Sysmon & Wazuh
- 409 real Windows Security events analyzed
- 6 of 6 attack simulations with live alerts
- 52 PCAP packets from your network testing

## Next Steps (Choose One)

### Option 1: Review What Was Created
```bash
find SOC Cloud-Security/Unified-Cloud-Detection Automation/SOC-Automation -name "*.md" | head -10
```

This shows you all the documentation created. Each file has guidance on linking to your real lab evidence.

### Option 2: Link to Your Existing Evidence
1. Open `SOC/Endpoint-Detection/Windows-Sysmon-Investigation.md`
2. Replace `[link to real evidence]` with actual paths from your Azure lab
3. Repeat for `Cloud-Security/Unified-Cloud-Detection/Azure-Detection.md`

### Option 3: Customize for Your Tools
The setup created methodology for these tools:
- Microsoft Sentinel / KQL
- Sysmon (from your Azure lab)
- PowerShell detection
- Cloud CSPM

If you use different tools (Wazuh, ELK, Splunk), adapt the methodology to match.

### Option 4: Update MITRE Coverage
Open `SOC/MITRE-ATT&CK/COVERAGE-MATRIX.md`

For each lab you've completed, update the status:
- `METHODOLOGY` → `OBSERVED` (once you have real evidence)

Example:
```
T1059 (Command & Scripting Interpreter)
  Status: OBSERVED ← Updated from METHODOLOGY
  Evidence: Azure-Windows-Server-Lab/Attack-Simulation (6 of 6 combos)
```

## Verification

After setup, run the portfolio verification:
```bash
bash verify-portfolio.sh
```

This confirms:
- ✅ All files created successfully
- ✅ Git status is clean
- ✅ Author attribution is correct
- ✅ 23/23 labs still tracked
- ✅ README highlights in place

## Files Created Summary

| File | Purpose | Action |
|------|---------|--------|
| `SOC/Microsoft-Sentinel-KQL/README.md` | Purpose and methodology | Review, keep as-is |
| `SOC/Microsoft-Sentinel-KQL/KQL/*.kql` | Investigation queries | Adapt to your environment |
| `SOC/Endpoint-Detection/README.md` | EDR workflow | Review, customize |
| `SOC/Endpoint-Detection/Windows-Sysmon-Investigation.md` | Link to your Azure lab | Add your evidence paths |
| `SOC/MITRE-ATT&CK/COVERAGE-MATRIX.md` | Attack coverage | Update with your findings |
| `Cloud-Security/Unified-Cloud-Detection/*` | Multi-cloud detection | Link to GCP/Azure labs |
| `Automation/SOC-Automation/README.md` | Alert workflow | Adapt to your tools |
| `Automation/SOC-Automation/PLAYBOOK.md` | Human-in-the-loop design | Reference for automation safety |

## Troubleshooting

**Script failed?**
```bash
cat setup_*.log | tail -50
```
Look for "ERROR" or "FAILED" messages.

**Files not created?**
```bash
ls -la SOC/
ls -la Cloud-Security/Unified-Cloud-Detection/
```
If directories exist but files don't, check permissions: `ls -la setup-tools/`

**Want to run it again?**
```bash
rm setup_*.log  # Clean up old logs
bash setup-tools/portfolio-complete-setup.sh
```
It's safe to re-run; new files overwrite old ones.

## What's Next?

1. **For recruiters:** Your portfolio now shows both hands-on labs AND enterprise SOC knowledge
2. **For learning:** Use the generated files as templates for understanding Sentinel, KQL, MITRE mapping
3. **For real work:** Replace METHODOLOGY sections with OBSERVED once you execute against real infrastructure

---

**Full documentation:** See [README.md](./README.md) for complete details on each phase, customization, and advanced usage.

**Questions?** Check the generated files—each one has inline guidance on how to use it for your specific security tools and environment.
