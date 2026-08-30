# Wazuh Detection Engineering — Offline Rule Validation

> **Evidence classification: Synthetic / offline validation**
>
> This lab validates custom Wazuh authentication-rule logic against controlled test events. It does **not** claim live Wazuh Manager alert generation.

## Objective

Design and validate authentication detections that can support SOC triage of suspicious login activity, while keeping the validation method reproducible and explicit about its limitations.

## Detection Scenario

The simulated scenario is repeated failed authentication activity that could, in a real environment, warrant investigation for password spraying, brute force, credential stuffing, or account targeting.

The test data uses documentation-only RFC 5737 TEST-NET source addresses. No external systems were contacted.

## Architecture

```text
Controlled authentication event
          ↓
XML rule definition
          ↓
Python offline validation harness
          ↓
Expected vs. actual rule matches
          ↓
JSON / CSV evidence
          ↓
SOC triage interpretation
```

**Important limitation:** Wazuh Manager is not installed on the validation workstation. The rules are evaluated offline rather than through a live Wazuh Manager/`wazuh-logtest` pipeline.

## Detection Rules

| Rule | Logic | Level | Purpose |
|---|---|---:|---|
| `100001` | `if_sid = 5710` | 10 | Tests a child rule dependent on the Wazuh authentication parent classification |
| `100002` | `match = Failed password` | 12 | Detects controlled authentication-failure text |

The source XML for both rules is retained under [`Rules/`](Rules/).

### Rule 100001 — Parent-SID Dependent Detection

The rule uses `<if_sid>5710</if_sid>`. Offline validation therefore confirms the child-rule relationship when the controlled event is already classified with parent SID `5710`.

The rule itself does **not** implement an attempt counter. Frequency/correlation would need to be supplied by the surrounding Wazuh detection logic or a higher-level correlation mechanism.

### Rule 100002 — Authentication Failure Match

The rule uses `<match>Failed password</match>`. Controlled events containing that exact text are expected to match rule `100002`.

## Validation Method

The Python harness:

1. Parses and validates the XML rule definitions.
2. Loads controlled authentication events.
3. Evaluates the supported rule conditions.
4. Compares expected and actual rule IDs.
5. Produces machine-readable JSON and CSV evidence.
6. Can be rerun to verify deterministic results.

## Test Cases

| Event | Scenario | Expected | Actual | Result |
|---|---|---|---|---|
| `EVT-001` | Failed authentication | `100001`, `100002` | `100001`, `100002` | PASS |
| `EVT-002` | Failed authentication | `100001`, `100002` | `100001`, `100002` | PASS |
| `EVT-003` | Successful-login control | None | None | PASS |

The controlled failed-authentication events use `192.0.2.10` and `192.0.2.11`; these are documentation-only addresses and were not used to contact external systems.

## Evidence

- [`Reports/Wazuh-Detection-Engineering-Offline-Validation.md`](Reports/Wazuh-Detection-Engineering-Offline-Validation.md) — full validation report
- [`Evidence/test-events.json`](Evidence/test-events.json) — controlled input events
- [`Evidence/rule-validation.json`](Evidence/rule-validation.json) — structured validation results
- [`Evidence/rule-validation.csv`](Evidence/rule-validation.csv) — tabular validation results
- [`Rules/authentication-failure-rule.xml`](Rules/authentication-failure-rule.xml) — rule `100001`
- [`Rules/suspicious-login-rule.xml`](Rules/suspicious-login-rule.xml) — rule `100002`
- [`Scripts/offline_rule_validator.py`](Scripts/offline_rule_validator.py) — validation harness

## SOC Triage Interpretation

In a live environment, an authentication-failure alert should be investigated using context such as:

- source IP and asset ownership
- targeted username/account
- attempt frequency and time window
- authentication outcome
- host and geographic context where available
- related successful logins
- other activity from the same source
- allow-lists and known administrative activity

A single failed authentication is usually weak evidence. Repetition, correlation and surrounding telemetry determine whether escalation is warranted.

## MITRE ATT&CK Context

The simulated repeated authentication-failure behaviour is contextually relevant to **T1110 — Brute Force**. This is a behavioural mapping only; it is not attribution and does not demonstrate a real compromise.

## False Positives & Tuning

Potential benign causes include:

- users entering an incorrect password
- expired or cached credentials
- service accounts with stale credentials
- administrative scripts using outdated secrets
- expected authentication failures during account maintenance

Production tuning should consider thresholds, account type, source reputation, asset criticality, allow-lists, successful-login correlation, suppression and alert severity.

## Findings

The offline harness correctly matched the expected rules for the two controlled failed-authentication events and produced no match for the successful-login control. This demonstrates deterministic validation of the implemented rule conditions.

It does **not** demonstrate that a live Wazuh Manager would decode, correlate, alert, or prioritise the same events identically.

## Production Validation Gap

A production-style validation would require a dedicated Wazuh Manager environment and should include:

1. decoder and rule loading
2. `wazuh-logtest` execution
3. live alert generation
4. rule-level output capture
5. correlation/frequency testing
6. false-positive testing
7. severity/tuning review

Those steps are intentionally listed as future validation rather than presented as completed evidence.

## Security & Ethics

All testing in this project uses controlled synthetic data and documentation-only network addresses. No external system was targeted or accessed.
