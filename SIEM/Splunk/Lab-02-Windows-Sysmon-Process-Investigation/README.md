# Splunk SOC Lab 02 — Windows / Sysmon Process Investigation

> **Evidence classification: Executed local training lab using synthetic telemetry.**

## Objective

Investigate Windows process creation telemetry using Sysmon-style Event ID 1 records and Splunk SPL.

The lab focuses on:

- Process creation
- Parent → child relationships
- PowerShell activity
- Command-line analysis
- Suspicious execution chains
- Timeline reconstruction
- Detection-oriented SPL
- SOC evidence and reporting

## Relationship to Splunk Lab 01

This lab builds directly on:

**Lab 01 — SSH Authentication Threat Hunting**

Lab 01 established source/account analysis, authentication correlation and timeline reconstruction.

Lab 02 extends the same methodology into endpoint telemetry:

`Authentication → Endpoint → Process → Detection → Investigation`

See:

`../Lab-01-SSH-Authentication-Hunting/README.md`

for the preceding investigation.

## Dataset

`data/sysmon_process_creation.csv`

The dataset contains synthetic Sysmon Event ID 1-style records.

## Execution status

- [x] Synthetic Sysmon dataset generated
- [x] Dedicated Splunk index configured
- [x] Dataset ingested
- [x] Process creation investigation executed
- [x] Parent/child analysis executed
- [x] PowerShell investigation executed
- [x] Suspicious command-line analysis executed
- [x] Detection-oriented SPL created
- [x] Investigation report generated
- [x] Dashboard definition generated
- [x] Dashboard REST validation attempted
- [ ] SOC monitoring dashboard screenshot captured

> The screenshot checkbox must remain unchecked until the dashboard is visually opened and genuinely captured.

## Evidence

See:

`evidence/README.md`

## Main artifacts

- `spl/process-investigation.spl`
- `spl/detection-rules.spl`
- `reports/SOC-Investigation-Report.md`
- `dashboard/SOC-Windows-Sysmon-Process-Investigation.md`
- `dashboard/dashboard-studio.json`

## Safety

No real customer, employer, credential, private infrastructure or production telemetry is used.


---

# 20-Section Evidence-First Case Study Record

> **Standard:** Permanent portfolio case-study standard. This record maps the existing lab evidence to the required 20-section structure without inventing execution claims.

**Evidence state:** CONTROLLED / SYNTHETIC

## 1. Scenario
The scenario documented in this README is authoritative; no new scenario is inferred.
## 2. Business / Technical Context
The documented technical environment and training/business context above define scope. Production impact is not claimed unless evidenced.
## 3. Objective
The objective is the explicitly documented investigation, validation, detection, engineering, or monitoring outcome.
## 4. Environment / Scope
Only explicitly named hosts, datasets, services, indexes, tools, and authorized systems are in scope.
## 5. Tools Used
Only tools evidenced in the existing README and retained artifacts are treated as used.
## 6. Investigation / Methodology
Follow the documented workflow: collect or generate authorized data, analyze, validate, interpret, and preserve evidence.
## 7. Commands / Scripts Used
Commands and scripts remain in their existing paths; execution is claimed only where the lab already records it.
## 8. Evidence
Retained datasets, screenshots, reports, rules, scripts, outputs, and logs referenced by the lab are the evidence set.
## 9. Indicators / Observations
Only observed results from retained evidence are recorded as indicators or observations.
## 10. Analysis
Analysis distinguishes raw observations from interpretation and preserves benign explanations where supported.
## 11. Findings
Findings are limited to those documented in the lab's existing analysis and evidence.
## 12. Risk / Impact
Risk is scoped to the lab. No customer, employer, breach, or production-impact claim is inferred.
## 13. Recommended Actions
Actions are the documented remediation, tuning, hardening, validation, or follow-up measures supported by findings.
## 14. Detection / Monitoring Opportunities
Detection and monitoring opportunities are those demonstrated or explicitly proposed; pending detections remain pending.
## 15. MITRE ATT&CK Mapping
Existing justified mappings are retained. No unsupported techniques are added.
## 16. Lessons Learned
Lessons derive from documented execution, troubleshooting, validation, or methodology, including useful failed approaches.
## 17. Skills Demonstrated
Skills are limited to capabilities evidenced by the actual lab artifacts and execution record.
## 18. Portfolio / SOC Relevance
The lab demonstrates the relevant SOC/security workflow without converting training evidence into production experience.
## 19. Evidence & Limitations
**CONTROLLED / SYNTHETIC.** Synthetic/offline evidence remains synthetic/offline; dataset and environmental limitations remain explicit.
## 20. References / Source Material
Existing linked artifacts, datasets, scripts, reports, standards, and source material remain the authoritative references.

### Evidence Integrity Statement
No fabricated metrics, incidents, certifications, production claims, or execution results are introduced by this standardization.
