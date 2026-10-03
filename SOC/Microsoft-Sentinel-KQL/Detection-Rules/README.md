# Sentinel Detection Engineering

## Detection lifecycle

The Sentinel detection model follows the same engineering discipline used by the portfolio's Wazuh/Sigma detections:

**Detection concept → telemetry → query → analytic rule → test → expected result → actual result → tuning**

## Candidate detections

### Authentication anomaly
**Telemetry:** `SigninLogs`

Potential signals:
- repeated authentication failures
- unusual source IP
- unusual location
- unexpected application
- suspicious authentication requirement

### Suspicious PowerShell
**Telemetry:** `DeviceProcessEvents`

Potential signals:
- encoded commands
- download activity
- suspicious execution chains
- unusual parent process
- script interpreter abuse

### Suspicious process relationship
**Telemetry:** `DeviceProcessEvents`

Potential signals:
- unexpected parent/child relationships
- scripting interpreters launched by unusual applications
- administrative tools executing from unusual contexts

### Suspicious network activity
**Telemetry:** `DeviceNetworkEvents`

Potential signals:
- unusual destination
- unexpected process/network relationship
- abnormal outbound connection pattern
- suspicious remote port

## False-positive handling

A production detection should not be considered complete simply because it returns results.

Analysts should establish:
1. What legitimate behavior produces the signal?
2. What makes the suspicious case different?
3. Which fields provide useful context?
4. What exclusions are justified?
5. Can exclusions be scoped to known hosts/users/processes?
6. How will the rule be regression-tested?

## Validation status

Unless execution evidence is retained, these detections remain:
**PENDING LIVE VALIDATION**
