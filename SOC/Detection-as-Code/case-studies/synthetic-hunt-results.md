# Synthetic Hunt Results: Windows Process Detection

**Evidence state:** Executed by the repository's deterministic fixture runner; synthetic data only. No live endpoint, SIEM, or production hunt is claimed.

## Method

The runner evaluates each event in fixtures/synthetic-process-events.json with detections/detection_engine.py and compares the observed rule IDs with explicit expected outcomes. This is a repeatable logic check, not a measure of production detection efficacy.

## Results

| Fixture | Evidence type | Expected rule IDs | Actual rule IDs | Result |
|---|---|---|---|---|
| SYN-001 | synthetic | DE-001 | DE-001 | PASS |
| SYN-002 | synthetic | DE-002 | DE-002 | PASS |
| SYN-003 | synthetic | DE-003 | DE-003 | PASS |
| SYN-004 | synthetic-benign-control | None | None | PASS |
| SYN-005 | synthetic-benign-control | None | None | PASS |

## Summary

- Fixtures evaluated: 5
- Fixtures passing expected outcomes: 5
- Alerts emitted: 3
- Positive fixtures: 3 (SYN-001 through SYN-003)
- Benign controls: 2 (SYN-004 and SYN-005)
- Overall fixture check: PASS

## Interpretation and limitations

- Expected behavior is observed when the three synthetic suspicious-pattern fixtures produce their mapped alerts and both benign controls produce no alerts.
- These fixtures are hand-authored examples, not collected telemetry or validated attacker behavior.
- The checks do not establish precision, recall, false-positive rate, coverage, or resistance to evasion.
- Sigma field mappings and behavior must still be checked against the target SIEM and its actual event schema.
- Do not treat a match as proof of malicious activity; investigate process ancestry, user context, host criticality, signer, network activity, and approved administration.

