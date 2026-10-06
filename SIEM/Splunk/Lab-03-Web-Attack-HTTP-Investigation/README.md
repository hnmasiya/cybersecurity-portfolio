# Lab 03 — Web Attack / HTTP Investigation

## 1. Scenario
Controlled Splunk SOC investigation of synthetic HTTP/web-attack telemetry.

## 2. Business / Technical Context
The lab extends the Splunk progression from Windows/process investigation into application-layer web activity.

## 3. Objective
Investigate HTTP telemetry, identify suspicious web-attack patterns, validate observations, and preserve analyst evidence.

## 4. Environment / Scope
- Platform: Splunk
- Index: `splunk_lab_web`
- Sourcetype: `splunk:lab:web`
- Dataset: 15 synthetic events
- Scope: authorized local training environment
- Evidence type: controlled / synthetic

## 5. Tools Used
- Splunk
- SPL
- Repository evidence and investigation artifacts

## 6. Investigation / Methodology
1. Ingest the controlled dataset.
2. Validate the index and sourcetype.
3. Run the retained investigation searches.
4. Identify suspicious HTTP/application-layer observations.
5. Reconstruct relevant activity where supported.
6. Compare observations with expected validation results.
7. Record findings and limitations.

## 7. Commands / Queries Used
The lab retains its SPL and supporting validation artifacts. No command or query is claimed here unless retained in the repository.

## 8. Evidence
Track-level validation records 15 validated synthetic events, retained SPL and an investigation report.

## 9. Indicators / Observations
The evidence is synthetic training telemetry. Specific observations must be taken from the retained SPL/results rather than inferred from the dataset size.

## 10. Analysis
The lab demonstrates investigation of web/application telemetry and the transition from raw HTTP events to analyst-oriented findings.

## 11. Findings
The track-level validation confirms the controlled dataset was ingested and validated through the Splunk search pipeline.

## 12. Risk / Impact
The exercise demonstrates how web telemetry can support detection and investigation. It does not represent a real customer, employer, or production incident.

## 13. Recommended Actions
For a production workflow, correlate HTTP activity with host, identity, authentication and application telemetry before assigning malicious intent.

## 14. Detection / Monitoring Opportunities
- Suspicious HTTP request patterns
- Repeated attack indicators
- Source-based aggregation
- Application-layer anomaly detection

## 15. MITRE ATT&CK Mapping
ATT&CK mapping is only applied where a retained observation supports a specific technique. No additional technique is claimed by this README alone.

## 16. Lessons Learned
Web investigation requires both request-level analysis and contextual correlation.

## 17. Skills Demonstrated
SPL investigation, web telemetry analysis, evidence validation, SOC investigation and reporting.

## 18. Portfolio / SOC Relevance
This lab demonstrates the web-investigation stage of the portfolio's progression:
**Authentication → Endpoint → Web Investigation → Detection → Monitoring → Incident Investigation.**

## 19. Evidence & Limitations
- Synthetic telemetry only.
- Authorized local training scope.
- No production or customer telemetry.
- Completion is supported by track-level validation.
- No dashboard screenshot is claimed unless genuinely captured.

## 20. References / Source Material
- Parent Splunk SOC Lab Track README
- Retained SPL and investigation artifacts
- Master Lab Completion & Evidence Register

**Status: COMPLETE — CONTROLLED / SYNTHETIC.**


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
