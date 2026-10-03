# Microsoft Sentinel & KQL Security Operations

## Purpose

This project extends the portfolio's existing Wazuh and detection-engineering experience into the Microsoft Sentinel and Kusto Query Language (KQL) security-operations model.

The objective is to demonstrate transferable SIEM skills:
**Telemetry → Query → Detection → Triage → Investigation → ATT&CK mapping → Response**

## Validation status

The KQL content in this repository is documented detection and investigation logic.

Unless an execution artifact is explicitly retained, queries are classified as:
**ARCHITECTURE / METHODOLOGY**

They must not be presented as queries executed against a live Microsoft Sentinel workspace.

## Why Sentinel/KQL

Modern SOC environments commonly use Microsoft Sentinel, Microsoft Defender and related Microsoft security telemetry. KQL provides a practical language for querying authentication, process, endpoint and network telemetry.

This portfolio demonstrates both:
- SIEM experience using Wazuh
- Transferable KQL/Sentinel investigation methodology

## Investigation workflow

```
Security telemetry
       ↓
KQL investigation
       ↓
Suspicious activity identified
       ↓
Alert / incident triage
       ↓
Host + user + process analysis
       ↓
MITRE ATT&CK mapping
       ↓
Scope assessment
       ↓
Response recommendation
       ↓
Detection tuning
```

## Included investigations

| Investigation | Purpose |
|---|---|
| Authentication | Identify suspicious authentication activity |
| PowerShell | Investigate suspicious PowerShell execution |
| Process activity | Identify unusual process relationships |
| Network | Investigate suspicious outbound connections |

## Relationship to existing portfolio

The Sentinel work complements:
- `SOC/Detection-as-Code/`
- `SOC/Detection-Validation/`
- `SOC/Flagship-Investigation/`
- `Cloud-Security/Azure-Windows-Server-Lab/`
- `Endpoint-Security/Windows-Sysmon-Detection-Lab/`
- `Automation/SOC-Automation/`

The underlying analyst methodology remains the same regardless of SIEM.

## Evidence integrity

No live Sentinel execution, alert count, detection rate or incident outcome is claimed unless corresponding evidence is retained in the repository.
