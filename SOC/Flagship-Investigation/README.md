# Flagship SOC Investigation

## Purpose

This is the portfolio's primary end-to-end SOC investigation.

It demonstrates:

**Wazuh alert → triage → Windows/Sysmon telemetry → investigation → timeline → ATT&CK mapping → scope assessment → response → detection improvement**

### Evidence integrity

Every artifact is classified as one of:

- **OBSERVED / LIVE** — directly supported by retained lab telemetry or artifacts.
- **SYNTHETIC / SIMULATED** — intentionally generated for training.
- **ARCHITECTURE / METHODOLOGY** — design or planned workflow without execution evidence.
- **PENDING LIVE VALIDATION** — a test that still needs to be executed.

No timestamps, alerts, detection rates, incidents or outcomes should be invented.

## Live validated investigation

- [LSASS Sysmon → Wazuh validation](./Evidence/LSASS-Sysmon-Wazuh-20260830.md)

**Observed result:** Sysmon Event ID 10 from PowerShell accessing `lsass.exe` reached Wazuh Agent `003` and triggered custom Rule `100312` at level 13, mapped to MITRE ATT&CK `T1003.001`.

## Investigation

### 1. Executive Summary

A controlled laboratory PowerShell test generated a Windows Sysmon Process Access event targeting LSASS. Wazuh received the telemetry and generated the expected high-severity custom detection. The evidence supports investigation of LSASS process access, but does not establish successful credential extraction or compromise.

### 2. Incident Classification
- Environment: Controlled laboratory
- Detection platform: Wazuh
- Endpoint telemetry: Windows / Sysmon
- Production incident: **No**

### 3. Initial Detection

| Field | Observed value |
|---|---|
| Rule | `100312` |
| Severity | Level `13` |
| Host | `dc01-lab.lab.local` |
| Agent | `003 / dc01-lab` |
| Sysmon event | `10` — Process Access |
| Source | `powershell.exe` |
| Target | `lsass.exe` |
| GrantedAccess | `0x1010` |
| Event records | `17575`, `17580` |
| Observed UTC | `2026-08-30 08:35:23.419` / `08:35:30.544` |

### 4. Timeline

| Time | Event | Evidence | Analyst interpretation |
|---|---|---|---|
| 08:35:23.419 UTC | PowerShell accessed LSASS | Sysmon Event ID 10 / EventRecordID 17575 | Security-relevant process access |
| 08:35:23.977 UTC | Wazuh alert generated | Rule 100312 | Detection fired as expected |
| 08:35:30.544 UTC | Second PowerShell → LSASS access | Sysmon Event ID 10 / EventRecordID 17580 | Repeated behavior increased investigation value |
| 08:35:31.585 UTC | Wazuh alert generated | Rule 100312 | Detection fired again |

### 5. Host and Process Analysis

Observed source process:

`C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`

Observed target:

`C:\Windows\system32\lsass.exe`

The controlled test used `OpenProcess` with desired access `0x1010`. The endpoint telemetry recorded the initiating account as `LAB\\hazvinei` and the target account as `NT AUTHORITY\\SYSTEM`.

### 6. Network Evidence

No network activity is established by this test. Network evidence is therefore **not claimed**.

### 7. MITRE ATT&CK

| Behavior | ATT&CK | Evidence | Status |
|---|---|---|---|
| LSASS process access | T1003.001 — LSASS Memory | Sysmon Event ID 10 + Wazuh Rule 100312 | OBSERVED / LIVE |
| PowerShell execution | T1059.001 — PowerShell | Controlled PowerShell test | OBSERVED / LIVE |

### 8. Analyst Reasoning

The alert was investigated because an interactive PowerShell process requested access to the LSASS process. LSASS contains sensitive authentication material, so unexpected process access can warrant credential-access investigation.

The evidence supports the following chain:

**PowerShell → OpenProcess(LSASS, 0x1010) → Sysmon Event 10 → Wazuh Agent 003 → Rule 100312 → Level 13 alert**

A benign explanation must remain possible. Microsoft Defender also accessed LSASS with `0x1010` during the observed period, demonstrating why source process, user, authorization, timing and surrounding telemetry are important when tuning this detection.

The evidence does **not** demonstrate credential dumping, persistence, lateral movement or command-and-control.

### 9. Scope Assessment

Affected laboratory endpoint: `dc01-lab.lab.local`.

The observed activity was generated intentionally for detection validation. Scope is limited to the retained Sysmon and Wazuh evidence from this controlled test.

### 10. Response

No containment or eradication action was performed because this was a controlled validation test. In a real SOC investigation, the analyst would validate the source process and account, correlate process/authentication/network telemetry, determine whether the activity is authorized, and contain the endpoint if malicious credential-access behavior were confirmed.

### 11. Detection Improvement

- **Rule:** `100312`
- **Telemetry:** Windows Sysmon Event ID 10
- **Severity:** Level 13
- **ATT&CK:** `T1003.001`
- **Validated:** Yes — live endpoint telemetry reached Wazuh and triggered the rule.
- **False-positive consideration:** Legitimate security/administrative software can access LSASS; source process and context must be evaluated.
- **Tuning:** The rule focuses on LSASS as the target and suspicious process sources including PowerShell, command shell, Task Manager, ProcDump and Rundll32.

### 12. Evidence Index

- [Live LSASS Sysmon/Wazuh evidence](./Evidence/LSASS-Sysmon-Wazuh-20260830.md)

### 13. Final Analyst Assessment

**Detection validation: PASS.** The controlled test produced genuine Sysmon Event ID 10 telemetry, Wazuh received the events through the Windows Event Channel, and custom Rule `100312` generated level-13 alerts mapped to `T1003.001`.

The result validates the telemetry-to-detection pipeline. It does not claim a real-world compromise or successful credential extraction.

> This is a controlled laboratory case study and must not be presented as professional employment experience or a real-world breach.
