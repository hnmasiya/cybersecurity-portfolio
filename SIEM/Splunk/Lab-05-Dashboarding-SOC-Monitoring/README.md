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
