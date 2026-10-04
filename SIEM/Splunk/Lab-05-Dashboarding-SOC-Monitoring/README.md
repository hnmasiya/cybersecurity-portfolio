# Lab 05 — Dashboarding and SOC Monitoring

## 1. Scenario
Controlled SOC-monitoring exercise using synthetic security metrics in Splunk.

## 2. Business / Technical Context
The lab builds operational visibility on top of validated SOC telemetry and detection concepts.

## 3. Objective
Aggregate monitoring telemetry, validate SOC-oriented searches and document dashboard/monitoring evidence.

## 4. Environment / Scope
- Platform: Splunk
- Index: `splunk_lab_monitoring`
- Sourcetype: `splunk:lab:socmetrics`
- Dataset: 24 synthetic events
- Scope: authorized local training environment
- Evidence type: controlled / synthetic

## 5. Tools Used
- Splunk
- SPL
- Monitoring and validation artifacts

## 6. Investigation / Methodology
1. Ingest the controlled monitoring dataset.
2. Validate index and sourcetype.
3. Execute retained KPI/time-series searches.
4. Validate expected counts and required fields.
5. Review monitoring outputs and limitations.
6. Preserve the validated artifacts.

## 7. Commands / Queries Used
Monitoring SPL and validation artifacts are retained in the repository. No unretained execution result is claimed.

## 8. Evidence
Track-level validation records 24 validated synthetic SOC-metric events and retained monitoring artifacts.

## 9. Indicators / Observations
The telemetry is synthetic and represents controlled monitoring data rather than live operational metrics.

## 10. Analysis
The lab demonstrates aggregation and operational visibility as the bridge between detection engineering and incident investigation.

## 11. Findings
Track-level validation confirms the monitoring dataset and required search/field checks were executed.

## 12. Risk / Impact
Monitoring dashboards can improve analyst visibility, but synthetic training data cannot establish production KPI performance.

## 13. Recommended Actions
Production dashboards should be tied to authoritative telemetry, documented thresholds, ownership and defined response procedures.

## 14. Detection / Monitoring Opportunities
- Authentication and endpoint trends
- Alert-volume monitoring
- Time-series anomaly review
- SOC KPI aggregation

## 15. MITRE ATT&CK Mapping
ATT&CK mapping is not required for the dashboard itself; techniques should be mapped only to underlying observed security behaviours.

## 16. Lessons Learned
SOC monitoring is most useful when metrics remain connected to investigation and response workflows.

## 17. Skills Demonstrated
SPL aggregation, SOC monitoring, dashboard-oriented analysis, validation and security reporting.

## 18. Portfolio / SOC Relevance
This lab demonstrates the operational-monitoring stage of the Splunk SOC progression.

## 19. Evidence & Limitations
- Synthetic telemetry only.
- Authorized local training scope.
- No production KPI or detection-rate claim.
- Dashboard visual evidence is not claimed unless genuinely captured.

## 20. References / Source Material
- Parent Splunk SOC Lab Track README
- Retained SPL and monitoring artifacts
- Validation evidence
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
