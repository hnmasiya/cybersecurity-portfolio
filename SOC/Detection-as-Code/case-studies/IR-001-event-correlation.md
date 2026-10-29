# IR-001 — Cross-Event Correlation Exercise

**Evidence state:** SYNTHETIC / OFFLINE VALIDATION  
**Purpose:** Correlate a suspicious process event with nearby network and file telemetry using host, user, and UTC timestamp.  
**Environment:** Repository test harness only; no live endpoint or SIEM is queried.

## Correlation hypothesis

If a suspicious encoded-PowerShell process event is part of a document-driven execution chain, then network and file events on the same host and associated user within a defined time window may provide useful investigative context.

This is a hypothesis to test, not a conclusion that every related event is malicious.

## Correlation logic

The reference implementation in `detections/correlation_engine.py`:

1. Uses the existing process detection harness to identify an alert anchor.
2. Requires a parseable timezone-aware timestamp and a host identifier for the anchor.
3. Searches a configurable absolute time window (default: 300 seconds).
4. Requires a matching host; when both records provide a user, the user must match.
5. Attaches Sysmon Event ID 3 records with a destination IP as network context and Event ID 11 records with a target filename as file context.
6. Returns the anchor rule IDs, context event IDs, evidence types, and explicit limitations.

The implementation intentionally does not treat network/file-only events as process alerts and does not claim that a connection attempt resulted in transfer or that file creation means execution.

## Synthetic result

The fixture runner expects one anchor:

- **Anchor:** `IR001-E001`, Windows Security Event ID 4688, encoded PowerShell, detection `DE-001`.
- **Network context:** `IR001-E002`, Sysmon Event ID 3, outbound TCP/443 record.
- **File context:** `IR001-E003`, Sysmon Event ID 11, `%TEMP%\\invoice_update.ps1` file creation.
- **Benign control:** `IR001-E004` does not trigger a process alert or create a correlation anchor.

The network address `203.0.113.44` is reserved for documentation examples and is not a real indicator of compromise. The timeline is hand-authored and synthetic.

## Reproduce

From the repository root:

```bash
cd SOC/Detection-as-Code
python3 -m unittest discover -s Tests -v
python3 scripts/run_ir001_case.py --check
python3 scripts/run_ir001_correlation.py
```

## Regression coverage

Tests cover expected host/user/time correlation, a different host, events outside the window, a benign non-alert, invalid timestamps, user mismatch, and rejection of a negative time window.

## Interpretation and limitations

A match means only that records share the configured keys and fall within the configured time window. It does not prove causality, maliciousness, successful transfer, payload execution, persistence, or account compromise. Production use would require validation against the target SIEM's field mappings, timestamp semantics, data quality, event volume, and approved correlation rules. Synthetic results do not establish production detection performance.
