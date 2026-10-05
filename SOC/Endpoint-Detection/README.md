# Endpoint Detection & Response

## Purpose

This area consolidates the portfolio's Windows endpoint security evidence around an EDR/SOC investigation model.

The primary evidence source is the deployed Azure Windows Server 2022 lab, which has retained:
- Windows Security telemetry
- Sysmon telemetry
- Wazuh agent connectivity
- Wazuh-generated alerts
- PowerShell automation
- Active Directory telemetry
- endpoint detection analysis

## Endpoint detection workflow

```
Windows endpoint
      |
      ├──→ Security Events
      ├──→ Sysmon
      ├──→ Windows Defender
      |
      v
Wazuh collection
      |
      v
Detection
      |
      v
Triage
      |
      v
Process + user + host + network investigation
      |
      v
MITRE ATT&CK
      |
      v
Response
```

## Existing real evidence

See: `Cloud-Security/Azure-Windows-Server-Lab/Evidence/`

Important retained artifacts include:
- `raw-security-events.json`
- `raw-sysmon-events.json`
- `real-ad-analysis.json`
- `real-sysmon-analysis.json`
- `wazuh-agent-connection.txt`
- `wazuh-dashboard-agent-active.jpg`

## What the evidence demonstrates

The Azure lab provides real endpoint telemetry and demonstrates the ability to interpret detections in context rather than treating every alert as malicious.

The retained Sysmon analysis identified explainable activity including:
- PowerShell process/network activity
- controlled `notepad.exe` child process
- failed authentication event

These findings were tied back to the administrator's actual lab activity.

## EDR positioning

This portfolio demonstrates endpoint detection concepts and real Windows/Sysmon telemetry.

It does **not** claim production experience operating a commercial EDR platform such as CrowdStrike, SentinelOne or Microsoft Defender for Endpoint unless that platform has actually been used and evidenced.

## Analyst workflow

**Alert → host identification → user → process → parent process → command line → network → timeline → ATT&CK → scope → response → tuning**


---

# 20-Section Evidence-First Case Study Record

> **Standard:** Permanent portfolio case-study standard. This mapping preserves the existing content and makes the evidence state explicit without inventing missing execution evidence.

**Evidence state:** LIVE / REAL LAB

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
**LIVE / REAL LAB.** Evidence-state limitations, dataset constraints, unperformed steps, and environmental restrictions remain explicit.
## 20. References / Source Material
The existing linked artifacts, reports, scripts, datasets, standards, and source material remain authoritative.

### Evidence Integrity Statement
This standardization adds structure, not invented results. No fabricated metrics, certifications, incidents, production claims, or execution evidence are introduced.
