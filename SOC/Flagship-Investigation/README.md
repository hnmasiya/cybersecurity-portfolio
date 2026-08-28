# Flagship SOC Investigation

## Purpose

This is the portfolio's primary end-to-end SOC investigation.

It is intended to demonstrate:

**Wazuh alert → triage → Windows/Sysmon telemetry → investigation → timeline → ATT&CK mapping → scope assessment → response → detection improvement**

### Evidence integrity

This case must use repository evidence only.

Every artifact is classified as one of:

- **OBSERVED / LIVE** — directly supported by retained lab telemetry or artifacts.
- **SYNTHETIC / SIMULATED** — intentionally generated for training.
- **ARCHITECTURE / METHODOLOGY** — design or planned workflow without execution evidence.
- **PENDING LIVE VALIDATION** — a test that still needs to be executed.

No timestamps, alerts, detection rates, incidents or outcomes should be invented.

## Investigation

### 1. Executive Summary
_To be completed from actual evidence._

### 2. Incident Classification
- Environment: Controlled laboratory
- Detection platform: Wazuh
- Endpoint telemetry: Windows / Sysmon where available
- Production incident: **No**

### 3. Initial Detection
Record the actual Wazuh alert:
- Rule ID
- Severity
- Timestamp
- Host
- User
- Event source
- Process
- Command line

### 4. Timeline
| Time | Event | Evidence | Analyst interpretation |
|---|---|---|---|
| ACTUAL/PENDING | ACTUAL EVENT | LINK TO ARTIFACT | ANALYSIS |

### 5. Host and Process Analysis
Document actual:
- hostname
- OS
- account
- process
- parent/child relationship
- command line
- Sysmon Event IDs
- relevant Windows Event IDs

### 6. Network Evidence
Use only retained evidence:
- destination
- protocol
- port
- DNS
- PCAP
- connection timing

Sanitize sensitive infrastructure details before publication.

### 7. MITRE ATT&CK
Map only behavior actually evidenced.

| Behavior | ATT&CK | Evidence | Status |
|---|---|---|---|
| PowerShell, if evidenced | T1059.001 | Actual artifact | OBSERVED/PENDING |

### 8. Analyst Reasoning
Explain:
1. Why the alert was investigated.
2. What evidence supported the hypothesis.
3. What alternative explanations were considered.
4. Whether persistence was evidenced.
5. Whether credential access was evidenced.
6. Whether lateral movement was evidenced.
7. Whether command-and-control was evidenced.

### 9. Scope Assessment
Identify affected hosts/accounts and investigation limitations.

### 10. Response
Document actual containment, eradication and recovery actions.

If not executed, use **PENDING LIVE VALIDATION**.

### 11. Detection Improvement
Document:
- rule
- telemetry source
- severity
- ATT&CK mapping
- false-positive considerations
- tuning
- validation result

### 12. Evidence Index
Link directly to retained sanitized logs, screenshots, rules, scripts and reports.

### 13. Final Analyst Assessment
Summarize what can actually be concluded from the evidence.

> This is a controlled laboratory case study and must not be presented as professional employment experience or a real-world breach.
