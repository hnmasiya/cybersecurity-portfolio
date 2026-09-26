# SOC Investigation Report — Splunk Lab 02

## Case

**Lab:** Splunk SOC Lab 02 — Windows / Sysmon Process Investigation

**Evidence classification:** Authorized local training lab using synthetic telemetry.

## Scope

The investigation covers Windows Sysmon Event ID 1-style process creation telemetry indexed into:

- Index: `splunk_lab_sysmon`
- Sourcetype: `splunk:lab:sysmon`

## Execution results

- Total process creation events: **32**
- PowerShell events: **3**
- Suspicious process/command-line events identified by the lab detection logic: **2**

## Investigation approach

1. Establish baseline process creation volume.
2. Identify common processes.
3. Examine parent → child relationships.
4. Isolate PowerShell execution.
5. identify suspicious command-line indicators.
6. Examine high-integrity processes.
7. Reconstruct the process timeline.
8. Validate detection logic against observed telemetry.

## Relationship to Lab 01

Lab 01 investigated SSH authentication telemetry, including source IPs, target accounts, authentication outcomes and timelines.

Lab 02 extends the same SOC investigation workflow into Windows endpoint telemetry.

The conceptual progression is:

`Authentication → Host activity → Process execution → Detection → Investigation`

## Evidence limitations

The dataset is synthetic. Suspicious-looking process chains demonstrate investigation and detection technique but do not prove that a real system was compromised.

## MITRE ATT&CK

Potential mappings are documented only where the synthetic telemetry and detection logic provide supporting evidence. No ATT&CK technique should be represented as observed beyond what the dataset actually demonstrates.

## Next investigative step

In a real SOC, correlate process creation with authentication, network, endpoint, persistence and security-control telemetry before making an incident determination.
