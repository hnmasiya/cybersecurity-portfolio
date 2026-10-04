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
