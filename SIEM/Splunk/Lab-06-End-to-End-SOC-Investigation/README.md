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
