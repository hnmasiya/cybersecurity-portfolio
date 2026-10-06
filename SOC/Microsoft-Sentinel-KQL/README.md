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


---

# 20-Section Evidence-First Case Study Record

> **Standard:** Permanent portfolio case-study standard. This mapping preserves the existing content and makes the evidence state explicit without inventing missing execution evidence.

**Evidence state:** ARCHITECTURE / METHODOLOGY

## 1. Scenario
Use only the scenario already documented above; no new incident or attacker activity is inferred.
## 2. Business / Technical Context
The existing README and retained artifacts define the technical and training context. Production business impact is not inferred.
## 3. Objective
The documented objective is authoritative and is not expanded beyond retained evidence.
## 4. Environment / Scope
Scope is limited to explicitly documented systems, datasets, repositories, services, simulations, and authorized infrastructure.
## 5. Tools Used
Only tools represented in the existing documentation or retained artifacts are treated as used.
## 6. Investigation / Methodology
The documented workflow is the methodology: evidence acquisition or generation, validation, analysis, interpretation, and reporting.
## 7. Commands / Scripts Used
Existing commands and scripts are retained in their documented locations; no execution is claimed merely because code exists.
## 8. Evidence
The retained evidence set consists only of the artifacts explicitly linked or described by this case study.
## 9. Indicators / Observations
Indicators and observations are limited to recorded results. Synthetic or simulated indicators remain labelled accordingly.
## 10. Analysis
Observed facts are separated from interpretation; unsupported conclusions are excluded.
## 11. Findings
Findings are those already supported by the retained evidence and documented analysis.
## 12. Risk / Impact
Risk statements are scoped to the documented environment. No production breach, customer impact, or employer engagement is implied.
## 13. Recommended Actions
Recommendations follow directly from documented findings, detection gaps, hardening needs, or validation requirements.
## 14. Detection / Monitoring Opportunities
Only demonstrated or explicitly proposed detection/monitoring opportunities are presented as such; unexecuted work remains pending.
## 15. MITRE ATT&CK Mapping
Existing justified ATT&CK mappings are retained; no mappings are invented to fill space.
## 16. Lessons Learned
Lessons reflect documented execution, troubleshooting, validation, and methodology.
## 17. Skills Demonstrated
Skills are limited to those supported by actual retained work and evidence.
## 18. Portfolio / SOC Relevance
The case study is framed as evidence of the corresponding security workflow without overstating professional experience.
## 19. Evidence & Limitations
**ARCHITECTURE / METHODOLOGY.** Evidence-state limitations, dataset constraints, unperformed steps, and environmental restrictions remain explicit.
## 20. References / Source Material
The existing linked artifacts, reports, scripts, datasets, standards, and source material remain authoritative.

### Evidence Integrity Statement
This standardization adds structure, not invented results. No fabricated metrics, certifications, incidents, production claims, or execution evidence are introduced.
