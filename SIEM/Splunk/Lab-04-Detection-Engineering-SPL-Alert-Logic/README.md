# Lab 04 — Detection Engineering and SPL Alert Logic

## 1. Scenario
Controlled detection-engineering exercise using synthetic Splunk telemetry.

## 2. Business / Technical Context
The lab converts observations from the web-investigation stage into repeatable SPL detection logic.

## 3. Objective
Develop, execute and validate detection-oriented SPL against controlled telemetry.

## 4. Environment / Scope
- Platform: Splunk
- Index: `splunk_lab_detection`
- Sourcetype: `splunk:lab:detection`
- Dataset: 6 synthetic events
- Scope: authorized local training environment
- Evidence type: controlled / synthetic

## 5. Tools Used
- Splunk
- SPL
- Detection and validation artifacts

## 6. Investigation / Methodology
1. Ingest the controlled dataset.
2. Validate index and sourcetype.
3. Execute retained detection SPL.
4. Compare expected and actual observations.
5. Review detection behaviour and limitations.
6. Preserve the validation result.

## 7. Commands / Queries Used
Detection SPL and supporting validation artifacts are retained in the repository. No unretained command or result is claimed.

## 8. Evidence
Track-level validation records 6 validated synthetic events, retained detection rules and a validation report.

## 9. Indicators / Observations
The evidence is controlled synthetic telemetry. Detection observations are limited to what the retained validation artifacts demonstrate.

## 10. Analysis
The exercise demonstrates the transition from investigation findings into testable detection logic.

## 11. Findings
The track-level validation confirms the detection dataset and required search/field validation were executed successfully.

## 12. Risk / Impact
Detection logic can support SOC alert generation, but controlled validation does not establish production detection performance.

## 13. Recommended Actions
Production deployment should include representative telemetry, benign controls, false-positive review, tuning and ongoing validation.

## 14. Detection / Monitoring Opportunities
- SPL-based behavioural detection
- Alert thresholds and aggregation
- Benign-control testing
- Detection regression testing

## 15. MITRE ATT&CK Mapping
Only map a technique when the underlying observed behaviour supports it. No unsupported ATT&CK claim is made here.

## 16. Lessons Learned
A detection should be validated against expected behaviour rather than treated as complete merely because the rule exists.

## 17. Skills Demonstrated
Detection engineering, SPL, validation, alert logic, evidence handling and SOC methodology.

## 18. Portfolio / SOC Relevance
This is the detection-engineering stage connecting web investigation to SOC monitoring.

## 19. Evidence & Limitations
- Synthetic telemetry only.
- Authorized local training scope.
- No production alert-rate or false-positive metric is claimed.
- No dashboard screenshot is claimed unless genuinely captured.

## 20. References / Source Material
- Parent Splunk SOC Lab Track README
- Retained detection SPL/rules
- Validation report
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
