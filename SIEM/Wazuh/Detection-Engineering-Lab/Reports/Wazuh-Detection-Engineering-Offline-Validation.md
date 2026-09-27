# Wazuh Detection Engineering — Offline Rule Validation

## Objective

Validate the existing custom Wazuh authentication rules against controlled synthetic authentication events without claiming live Wazuh Manager execution.

## Skills & Tools

- Wazuh custom rule XML
- Python
- XML parsing and validation
- Detection logic testing
- Authentication event analysis
- SOC triage
- Evidence preservation
- MITRE ATT&CK contextual mapping

## Architecture

Wazuh Manager is not installed on the current workstation. The rules are therefore evaluated offline using a deterministic Python validation harness that reads the XML rule conditions and applies them to controlled test events.

## Topology

Synthetic authentication event → XML rule parser → rule-condition evaluation → validation evidence → SOC interpretation

## Execution

Two existing custom rules were copied into the project:

- Rule `100001` — depends on parent SID `5710`
- Rule `100002` — matches the text `Failed password`

Three controlled authentication events were then evaluated.

## Walkthrough

1. Validated both custom rule files as XML.
2. Created two failed-authentication events.
3. Created one successful-authentication control event.
4. Parsed the `if_sid` and `match` conditions.
5. Compared actual matches with expected rule IDs.
6. Produced JSON and CSV evidence.
7. Re-ran the validator to confirm reproducibility.

## Attack Simulation

The failed-authentication events simulate SSH password-guessing activity using documentation-only RFC 5737 TEST-NET addresses:

- `192.0.2.10`
- `192.0.2.11`

No external systems were contacted.

## Detection

### Rule 100001

The rule contains:

`<if_sid>5710</if_sid>`

Therefore, the offline validation confirms that an event already classified under parent SID `5710` matches rule `100001`.

The XML itself does not implement an attempt counter; frequency/correlation is supplied by the surrounding Wazuh detection logic.

### Rule 100002

The rule contains:

`<match>Failed password</match>`

Therefore, events containing that exact authentication failure text matched rule `100002`.

## Triage

Failed-authentication alerts should be assessed using:

- Source IP
- Targeted username
- Attempt frequency
- Authentication outcome
- Host context
- Related successful logins
- Other activity from the same source

## Investigation

The test evidence correlates:

- Event ID
- Parent SID
- Source IP
- Username
- Message content
- Matched rule IDs

The two failed-authentication events matched both custom rules. The successful-login control event matched neither.

## Evidence

- `Evidence/test-events.json`
- `Evidence/rule-validation.json`
- `Evidence/rule-validation.csv`
- `Rules/authentication-failure-rule.xml`
- `Rules/suspicious-login-rule.xml`
- `Scripts/offline_rule_validator.py`

## Findings

Offline validation produced:

| Event | Expected | Actual | Result |
|---|---|---|---|
| EVT-001 | 100001, 100002 | 100001, 100002 | PASS |
| EVT-002 | 100001, 100002 | 100001, 100002 | PASS |
| EVT-003 | None | None | PASS |

## Impact

In a production environment, repeated failed authentication can indicate brute-force attacks, credential stuffing, password spraying, or account targeting.

This project contains synthetic events only and does not demonstrate a real compromise.

## Root Cause

The laboratory validation is synthetic. There is no production incident or real-world root cause.

## MITRE ATT&CK

Potential contextual mapping:

- T1110 — Brute Force

This mapping describes the simulated authentication behaviour and is not attribution.

## Remediation

Detection engineering should correlate failed authentication attempts over time and consider:

- Attempt thresholds
- Account context
- Source reputation
- Successful-login correlation
- Allow-lists
- Alert suppression and tuning

## Validation

Offline validation passed for all three controlled events.

Live validation with `/var/ossec/bin/wazuh-logtest` was **not performed** because Wazuh Manager is not installed on this workstation.

## Lessons Learned

Detection rules must be tested against known inputs, and offline rule validation must be clearly distinguished from live SIEM alert validation.

## Recommendations

Repeat the same test cases later in a dedicated Wazuh Manager lab using `wazuh-logtest`, then capture the actual decoder/rule output and generated alert as separate live evidence.
