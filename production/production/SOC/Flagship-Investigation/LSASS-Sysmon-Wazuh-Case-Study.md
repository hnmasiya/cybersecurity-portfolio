# LSASS Process-Access Detection Case Study

## Executive Summary

This controlled laboratory investigation demonstrates an end-to-end SOC detection workflow using Windows Sysmon and Wazuh. A PowerShell test generated process-access telemetry targeting `lsass.exe`; the telemetry was collected by Wazuh and matched a custom high-severity detection mapped to MITRE ATT&CK `T1003.001`.

The investigation demonstrates the analyst lifecycle:

**Controlled activity → endpoint telemetry → SIEM detection → triage → ATT&CK mapping → scope assessment → response decision → detection improvement**

This is a laboratory validation, not a production incident or real-world breach.

## Evidence Integrity

Evidence in this case study is classified as **OBSERVED / LIVE** where it is directly supported by retained laboratory telemetry. No successful credential extraction, persistence, lateral movement, command-and-control, or production compromise is claimed unless the retained evidence establishes it.

## Environment

| Field | Observed value |
|---|---|
| Environment | Controlled laboratory |
| Endpoint | `dc01-lab.lab.local` |
| Wazuh agent | `003 / dc01-lab` |
| Endpoint telemetry | Windows / Sysmon |
| SIEM | Wazuh |
| Detection rule | `100312` |
| Sysmon event | Event ID `10` — Process Access |
| ATT&CK | `T1003.001` — LSASS Memory |

## Attack Scenario

A controlled PowerShell test opened a handle to the Windows LSASS process using `OpenProcess` with desired access `0x1010`. The objective was to validate whether endpoint telemetry would reach Wazuh and trigger the custom credential-access detection.

The observed process chain was:

```text
PowerShell
    ↓
OpenProcess(LSASS, 0x1010)
    ↓
Sysmon Event ID 10
    ↓
Wazuh Agent 003
    ↓
Custom Rule 100312
    ↓
Level 13 alert
```

## Endpoint Telemetry

The retained evidence records:

| Field | Observed value |
|---|---|
| Account | `LAB\\hazvinei` |
| Source process | `C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe` |
| Source PID | `6956` |
| Target process | `C:\\Windows\\system32\\lsass.exe` |
| Target PID | `716` |
| Granted access | `0x1010` |
| Sysmon Event ID | `10` |
| Event Record IDs | `17575`, `17580` |
| Observed UTC | `2026-08-30 08:35:23.419` and `08:35:30.544` |

The same test was observed on the Windows endpoint before the corresponding Wazuh records were confirmed.

## Wazuh Detection

The live telemetry triggered custom Rule `100312`:

**Credential Access: Process access targeting LSASS**

| Detection field | Value |
|---|---|
| Rule | `100312` |
| Severity | Level `13` |
| Telemetry | Sysmon Event ID `10` |
| Source | PowerShell |
| Target | `lsass.exe` |
| ATT&CK | `T1003.001` |
| Tactic | Credential Access |
| Agent | `003 / dc01-lab` |

The retained evidence records two matching PowerShell → LSASS events from the controlled test.

## Detection Logic

The validated detection correlates Sysmon Process Access events with:

1. a target image ending in `lsass.exe`; and
2. suspicious process sources such as PowerShell, command shell, Task Manager, ProcDump, or Rundll32.

The live PowerShell test matched the expected condition and produced the intended Wazuh alert.

## Correlated PowerShell Detection

The wider Attack Simulation & Detection Engineering Lab also validates encoded PowerShell execution using custom Rule `100201`, mapped to:

- `T1059.001` — PowerShell
- `T1027` — Obfuscated Files or Information

That detection establishes a second useful investigation signal: suspicious PowerShell execution involving an encoded command. When such telemetry occurs in temporal proximity to LSASS process access, an analyst should investigate the combined activity rather than treating either alert in isolation.

**Important:** this case study does not claim that the encoded-PowerShell event and the LSASS event constitute one single malicious intrusion unless the retained evidence establishes that correlation. The correlation is an analyst investigation methodology and risk-assessment consideration.

## Analyst Triage

A SOC analyst investigating the alert should validate:

- alert severity and detection rule;
- source process and executable path;
- target process;
- initiating user/account;
- parent process and process lineage;
- process IDs;
- command line;
- granted access;
- event timestamps and surrounding telemetry;
- related Sysmon events;
- related Wazuh alerts;
- ATT&CK technique mapping;
- whether the activity is authorized or expected.

The retained evidence supports the core process-access investigation, including the source process, target process, account, PIDs, granted access, timestamps, Sysmon event and Wazuh detection.

## Analyst Reasoning

LSASS contains sensitive authentication material, so unexpected process access to LSASS is security-relevant and can warrant credential-access investigation.

However, process access alone does not prove credential dumping. The investigation must distinguish:

**Observed behavior:** PowerShell accessed LSASS and generated Sysmon Event ID 10 telemetry that triggered Wazuh Rule `100312`.

**Not established by this evidence:** successful credential extraction, persistence, lateral movement, command-and-control, or compromise.

The endpoint also showed Microsoft Defender performing similar LSASS access. This demonstrates why source process, user, timing and surrounding telemetry matter when assessing and tuning detections.

## False-Positive Consideration

Legitimate administrative and security software may access LSASS. The detection therefore provides a strong investigation signal rather than an automatic declaration of compromise.

The portfolio's detection engineering work includes explicit suppression/tuning for known-good Defender LSASS access, while retaining detection coverage for suspicious sources. This illustrates the practical balance between detection sensitivity and alert fatigue.

## Scope Assessment

**Affected environment:** controlled laboratory endpoint `dc01-lab.lab.local`.

**Scope:** the retained Sysmon and Wazuh evidence associated with the controlled test.

**Production incident:** No.

No network activity is established by this test, so network compromise or command-and-control is not claimed.

## Response Decision

No containment or eradication action was performed because the activity was intentionally generated for detection validation.

In a real SOC environment, the analyst would validate the initiating process and user, correlate authentication/process/network telemetry, determine whether the activity is authorized, and contain the endpoint if malicious credential-access behavior were confirmed.

## Detection Engineering Outcome

The validation demonstrates a functioning telemetry-to-detection pipeline:

```text
Controlled Test
      ↓
PowerShell Activity
      ↓
Windows Sysmon
      ↓
Event ID 10 — Process Access
      ↓
Wazuh Agent 003
      ↓
Custom Rule 100312
      ↓
Level 13 Alert
      ↓
MITRE ATT&CK T1003.001
      ↓
SOC Analyst Triage
      ↓
Scope / Context Assessment
      ↓
Detection Tuning Considerations
```

The wider lab extends this workflow with encoded PowerShell detection (`100201`) and other execution, persistence and credential-access detections across Linux and Windows.

## Validation Result

**PASS — live endpoint telemetry reached Wazuh and triggered the intended custom detection.**

The evidence validates the detection pipeline and the rule's ability to identify the tested LSASS process-access behavior.

It does **not** establish a real-world breach or successful credential extraction.

## Evidence

- [Live LSASS Sysmon → Wazuh evidence](./Evidence/LSASS-Sysmon-Wazuh-20260830.md)
- [Flagship SOC Investigation README](./README.md)
- [Attack Simulation & Detection Engineering Lab](../../Offensive-Security/Attack-Simulation-Detection-Lab/README.md)

## Interview Talking Points

### What did you actually detect?

I validated a custom Wazuh detection against live Windows Sysmon telemetry. A controlled PowerShell process accessed `lsass.exe`, producing Sysmon Event ID 10 and a Level 13 Wazuh alert under Rule `100312`, mapped to `T1003.001`.

### Does the alert prove credential dumping?

No. It proves LSASS process access. I would investigate the source process, user, access rights, process lineage and surrounding telemetry before concluding that credentials were successfully extracted.

### How did you approach false positives?

I considered legitimate security software such as Microsoft Defender, which can also access LSASS. The detection therefore needs contextual validation and appropriate suppression/tuning for known-good activity.

### What did this demonstrate from a SOC perspective?

It demonstrated the complete detection lifecycle: generating controlled activity, collecting endpoint telemetry, creating and validating a SIEM rule, mapping the behavior to ATT&CK, triaging the alert, assessing scope, and documenting what the evidence does and does not prove.

> **Portfolio classification:** Controlled laboratory detection-engineering case study. Not professional employment experience and not a real-world breach.
