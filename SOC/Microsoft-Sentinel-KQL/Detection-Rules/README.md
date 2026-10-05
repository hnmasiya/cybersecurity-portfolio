# Sentinel Detection Engineering

## Detection lifecycle

The Sentinel detection model follows the same engineering discipline used by the portfolio's Wazuh/Sigma detections:

**Detection concept → telemetry → query → analytic rule → test → expected result → actual result → tuning**

## Candidate detections

### Authentication anomaly
**Telemetry:** `SigninLogs`

Potential signals:
- repeated authentication failures
- unusual source IP
- unusual location
- unexpected application
- suspicious authentication requirement

### Suspicious PowerShell
**Telemetry:** `DeviceProcessEvents`

Potential signals:
- encoded commands
- download activity
- suspicious execution chains
- unusual parent process
- script interpreter abuse

### Suspicious process relationship
**Telemetry:** `DeviceProcessEvents`

Potential signals:
- unexpected parent/child relationships
- scripting interpreters launched by unusual applications
- administrative tools executing from unusual contexts

### Suspicious network activity
**Telemetry:** `DeviceNetworkEvents`

Potential signals:
- unusual destination
- unexpected process/network relationship
- abnormal outbound connection pattern
- suspicious remote port

## False-positive handling

A production detection should not be considered complete simply because it returns results.

Analysts should establish:
1. What legitimate behavior produces the signal?
2. What makes the suspicious case different?
3. Which fields provide useful context?
4. What exclusions are justified?
5. Can exclusions be scoped to known hosts/users/processes?
6. How will the rule be regression-tested?

## Validation status

Unless execution evidence is retained, these detections remain:
**PENDING LIVE VALIDATION**


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
