# Detection Validation

A validation framework for the portfolio's Wazuh/Sysmon detection engineering.

## Objective

Evaluate detections against both suspicious and benign behavior rather than simply stating that an alert appeared.

## Matrix

| Test | Expected | Actual | Status |
|---|---|---|---|
| Controlled suspicious simulation | Alert | PENDING | PENDING LIVE VALIDATION |
| Benign administrative activity | No alert | PENDING | PENDING LIVE VALIDATION |
| Repeated suspicious execution | Defined behavior | PENDING | PENDING LIVE VALIDATION |
| Similar benign behavior | No false positive | PENDING | PENDING LIVE VALIDATION |

## Metrics

Only calculate these from executed tests:

- test cases
- successful detections
- detection rate
- false positives
- false negatives, if demonstrable
- detection latency, if measurable
- severity distribution
- ATT&CK coverage

Never estimate missing metrics.

## Evidence chain

**Test action → telemetry → detection → alert → analyst validation → tuning**

A detection is not marked validated merely because the rule exists.
