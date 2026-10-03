# Portfolio Setup Tools

This directory contains automation scripts for building and verifying your cybersecurity portfolio structure.

## Portfolio Complete Setup Script

### `portfolio-complete-setup.sh`

A comprehensive automation script that builds the complete portfolio structure across all security domains in a single execution.

#### What it Creates

The script automates creation of 19 documented sections across your portfolio:

**Security Operations & Detection (SOC)**
- Microsoft Sentinel & KQL investigation methodology
  - KQL queries for authentication, process, network investigation
  - Detection rule engineering documentation
  - MITRE ATT&CK mapping for Sentinel-based findings
  
**Endpoint Detection & Response (EDR)**
- Windows Sysmon investigation methodology (building on your Azure lab)
- PowerShell investigation patterns and analyst decision-making
- Real evidence interpretation from your live infrastructure

**MITRE ATT&CK Coverage**
- Attack technique matrix with evidence classification
- Clear distinction between OBSERVED (live evidence) and METHODOLOGY (documented approach)

**Cloud Detection Unification**
- Azure detection scenarios (linking to your existing evidence)
- GCP Cloud Security Posture Management (CSPM) patterns
- Cloud ATT&CK mapping for multi-cloud environments

**SOC Automation**
- Alert enrichment playbook with human-in-the-loop workflow
- Evidence integrity and validation procedures
- Automation safety boundaries and approval gates

#### How to Run

**Basic Usage:**
```bash
./portfolio-complete-setup.sh
```

This runs the setup in your current directory. It will create the following structure:
```
SOC/
  Microsoft-Sentinel-KQL/
    KQL/
    Detection-Rules/
  Endpoint-Detection/
  MITRE-ATT&CK/

Cloud-Security/
  Unified-Cloud-Detection/

Automation/
  SOC-Automation/
```

**Run in a Specific Directory:**
```bash
./portfolio-complete-setup.sh /path/to/portfolio
```

#### Output

The script:
- Creates all necessary directories
- Generates comprehensive documentation files (README, methodology, queries, playbooks)
- Produces a timestamped log file: `setup_YYYYMMDD_HHMMSS.log`
- Verifies file creation and reports any issues
- Color-codes output for easy monitoring

#### What Each Phase Does

| Phase | Purpose | Output |
|-------|---------|--------|
| 1 | Create SOC directory structure | 6 new directories |
| 2-7 | Sentinel/KQL documentation | README, 4 KQL queries, Detection Rules, ATT&CK mapping |
| 8-10 | Endpoint Detection methodology | EDR README, Sysmon investigation, PowerShell patterns |
| 11-13 | MITRE ATT&CK coverage | Coverage matrix with evidence classification |
| 14-16 | Cloud Detection unification | Azure, GCP, unified README with detection scenarios |
| 17-18 | SOC Automation | Alert playbook, enrichment workflow |
| 19 | Verification & logging | Final status check and timestamped log |

#### After Running

1. **Review the generated files** in each directory
2. **Customize methodology** to match your specific environment and tools
3. **Link to existing evidence** from your Azure lab and Wazuh infrastructure
4. **Add execution artifacts** from your real investigations (with sensitive data redacted)
5. **Update MITRE coverage** as you complete real investigations (change METHODOLOGY → OBSERVED)

#### Log File Analysis

The script creates a timestamped log file showing:
- When setup started and completed
- Which files were created
- Any verification warnings or issues
- Total execution time

Example:
```
setup_20260828_163800.log
```

View the log:
```bash
tail -20 setup_*.log
```

## Verification Script

The `verify-portfolio.sh` script (in the repository root) validates that your portfolio is:
- Properly committed to git
- Has correct author attribution
- Contains all expected documentation files
- Shows correct lab completion status
- Has README highlights properly formatted

Run it from your portfolio root:
```bash
bash verify-portfolio.sh
```

## Integration with Existing Portfolio

Both scripts work with your existing structure:

✅ Your Azure Windows Server lab (real DC, Wazuh, Sysmon)
✅ Your 23/23 completed labs and evidence
✅ Your lab tracker and case studies
✅ Your existing GitHub repository

The setup script adds enterprise SOC methodology documentation alongside your existing labs, creating a cohesive portfolio that demonstrates both:
- Hands-on security engineering (your labs)
- Enterprise detection and automation (new documentation)

## File Structure After Setup

```
cybersecurity-portfolio/
├── setup-tools/                           # ← You are here
│   ├── README.md                         # This file
│   └── portfolio-complete-setup.sh       # Automation script
├── SOC/
│   ├── Microsoft-Sentinel-KQL/          # NEW: Sentinel methodology
│   ├── Endpoint-Detection/              # NEW: EDR investigation patterns
│   └── MITRE-ATT&CK/                    # NEW: Attack coverage
├── Cloud-Security/
│   ├── Unified-Cloud-Detection/         # NEW: Multi-cloud detection
│   └── Azure-Windows-Server-Lab/        # EXISTING: Your real lab
├── Automation/
│   ├── SOC-Automation/                  # NEW: Alert playbook
│   └── ...                               # EXISTING: Your scripts
└── [other existing directories unchanged]
```

## Quick Start Summary

1. **Run the setup:**
   ```bash
   cd /path/to/portfolio
   bash setup-tools/portfolio-complete-setup.sh
   ```

2. **Review the log:**
   ```bash
   tail setup_*.log
   ```

3. **Verify overall portfolio:**
   ```bash
   bash verify-portfolio.sh
   ```

4. **Customize and link:**
   - Open generated files and add your real evidence references
   - Update MITRE mapping with your lab findings
   - Enhance with execution artifacts from your infrastructure

5. **Commit your updates:**
   ```bash
   git add SOC/ Cloud-Security/ Automation/
   git commit -m "Add enterprise SOC methodology and detection framework"
   ```

## Notes

- The script is **idempotent**: running it multiple times in the same directory is safe; new files overwrite old ones
- **No external dependencies**: Uses only standard bash, mkdir, cat, and date
- **Fast execution**: Typically completes in under 2 seconds
- **Safe**: Doesn't delete or modify existing files (only creates new ones)
- **Logging**: All output captured in timestamped log for review

## Support

If the setup encounters issues:
1. Check the log file: `cat setup_*.log`
2. Verify disk space: `df -h`
3. Ensure write permissions: `ls -la`
4. Review error messages in the log for specific file creation issues

---

**Next Steps:** After running the setup, see each generated README for guidance on linking to your real lab evidence, updating MITRE coverage, and customizing the methodology for your specific security tools and environment.
