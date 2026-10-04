# Lab 06 — End-to-End SOC Investigation and Incident Report

## 1. Scenario
Controlled end-to-end SOC investigation using synthetic case telemetry.

## 2. Business / Technical Context
The final Splunk lab combines telemetry review, sequencing, investigation logic and incident reporting.

## 3. Objective
Reconstruct a controlled security case, correlate available evidence, document findings and produce an analyst-oriented incident report.

## 4. Environment / Scope
- Platform: Splunk
- Index: `splunk_lab_case`
- Sourcetype: `splunk:lab:case`
- Dataset: 6 synthetic case events
- Scope: authorized local training environment
- Evidence type: controlled / synthetic

## 5. Tools Used
- Splunk
- SPL
- Investigation/reporting artifacts

## 6. Investigation / Methodology
1. Ingest the controlled case dataset.
2. Validate index and sourcetype.
3. Establish the investigation hypothesis from available telemetry.
4. Run retained timeline/sequence searches.
5. Correlate relevant events and indicators.
6. Compare expected and actual observations.
7. Document findings, limitations and response considerations.

## 7. Commands / Queries Used
The repository retains the investigation SPL and supporting artifacts. No unretained command or result is claimed.

## 8. Evidence
Track-level validation records 6 validated synthetic case events, retained SPL and an incident report.

## 9. Indicators / Observations
The case evidence is synthetic. Conclusions are restricted to observations supported by the retained investigation artifacts.

## 10. Analysis
The lab demonstrates the complete progression from telemetry to investigation and reporting within a controlled SIEM environment.

## 11. Findings
Track-level validation confirms the controlled case dataset and investigative artifacts were executed and validated.

## 12. Risk / Impact
The exercise demonstrates incident-investigation methodology but is not evidence of a real-world compromise or production incident.

## 13. Recommended Actions
A production investigation should preserve evidence, establish scope, correlate identity/endpoint/network telemetry, document decisions and validate remediation.

## 14. Detection / Monitoring Opportunities
Investigation findings can feed back into detection rules, monitoring views and future validation cases.

## 15. MITRE ATT&CK Mapping
Techniques should be mapped only where the retained case evidence supports the behaviour.

## 16. Lessons Learned
An end-to-end SOC workflow requires evidence correlation, explicit limitations and clear separation between observed facts and analyst conclusions.

## 17. Skills Demonstrated
SOC investigation, SPL, timeline analysis, evidence handling, incident reporting and security analysis.

## 18. Portfolio / SOC Relevance
This is the culmination of the six-lab Splunk progression:
**Authentication → Endpoint → Web → Detection Engineering → Monitoring → End-to-End Investigation.**

## 19. Evidence & Limitations
- Synthetic telemetry only.
- Authorized local training scope.
- No production incident is claimed.
- No dashboard screenshot is claimed unless genuinely captured.
- Any response action beyond the retained simulation evidence must be treated as a recommendation, not an executed remediation.

## 20. References / Source Material
- Parent Splunk SOC Lab Track README
- Retained investigation SPL
- Incident report
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
