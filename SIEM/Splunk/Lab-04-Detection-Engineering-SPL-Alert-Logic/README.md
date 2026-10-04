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
