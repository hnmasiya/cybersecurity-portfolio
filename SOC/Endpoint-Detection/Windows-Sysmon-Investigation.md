# Windows / Sysmon Investigation

## Evidence source

The primary evidence is retained in:
`Cloud-Security/Azure-Windows-Server-Lab/Evidence/`

The lab contains real Sysmon and Windows telemetry collected from the deployed Windows Server 2022 environment.

## Relevant telemetry

| Event | Purpose |
|---|---|
| Sysmon Event ID 1 | Process creation |
| Sysmon Event ID 3 | Network connection |
| Security Event ID 4625 | Failed logon |

## Investigation process

1. Identify the host
2. Identify the user
3. Identify the process
4. Examine the parent process
5. Review command-line arguments
6. Review network activity
7. Establish the timeline
8. Determine whether behavior is malicious, benign or inconclusive
9. Map demonstrated behavior to ATT&CK
10. Determine response and tuning requirements

## Real lab findings

The retained endpoint analysis produced five findings from the captured telemetry.

The documented interpretation is important: the findings were explainable by actions performed during the lab deployment and testing.

This demonstrates an important SOC skill:
**Detection ≠ confirmed compromise**

Analysts must distinguish suspicious telemetry from malicious activity by examining context and corroborating evidence.
