# Windows / Sysmon Endpoint Detection Engineering Lab

## Objective

Demonstrate an evidence-driven endpoint detection workflow using synthetic Windows and Sysmon-style telemetry, with explicit separation between offline validation and live Windows endpoint evidence.

## Skills & Tools

- Windows Event Log concepts
- Sysmon telemetry concepts
- PowerShell detection
- Process creation analysis
- Authentication-event analysis
- Endpoint detection engineering
- MITRE ATT&CK mapping
- Python
- JSON evidence handling
- SOC triage

## Architecture

This laboratory is an offline endpoint-detection engineering project. A live Windows endpoint and Sysmon installation are not currently available in the repository.

Synthetic endpoint events are therefore evaluated by a deterministic Python validation harness.

## Topology

Synthetic Windows/Sysmon-style event
-> Detection logic
-> Python validator
-> Detection result
-> SOC triage
-> MITRE ATT&CK interpretation

## Execution

The project uses synthetic endpoint events representing common telemetry such as PowerShell process creation, failed authentication, network connections, and parent-child process relationships.

The validator evaluates each event against documented detection conditions.

## Walkthrough

1. Load synthetic endpoint events.
2. Load endpoint detection rules.
3. Evaluate each event against detection conditions.
4. Record matching rule IDs.
5. Map detections to MITRE ATT&CK context.
6. Preserve validation results as JSON.
7. Review false-positive and negative-test behaviour.

## Attack Simulation

The events are synthetic laboratory scenarios. They do not represent observed activity from a real compromised Windows host.

Scenarios include suspicious PowerShell execution, failed authentication, PowerShell network activity, and a PowerShell child process.

## Detection

The lab demonstrates detection concepts for:

- Suspicious PowerShell execution
- PowerShell network connections
- Windows failed authentication
- Suspicious child processes launched by PowerShell

## Triage

An analyst should review:

- Host
- User
- Parent process
- Process image
- Command line
- Source and destination information
- Event ID
- Frequency
- Related authentication activity

## Investigation

A production investigation should correlate endpoint telemetry with SIEM alerts, authentication logs, network connections, file activity, and user context.

This offline lab validates detection logic rather than a real endpoint investigation.

## Evidence

- `Data/synthetic-endpoint-events.json`
- `Rules/detection-rules.json`
- `Evidence/detection-validation.json`
- `Scripts/offline_endpoint_validator.py`

## Findings

The detection harness identifies the synthetic suspicious PowerShell, failed-authentication, network-connection, and child-process scenarios while allowing the benign successful-authentication event to remain below the alert threshold.

## Impact

Suspicious PowerShell activity, repeated authentication failures, and unusual process relationships can indicate execution, credential-attack, or post-compromise activity in a real Windows environment.

No production compromise is claimed.

## Root Cause

This laboratory demonstrates detection logic rather than investigating a confirmed endpoint compromise.

The principal limitation is that live Windows/Sysmon telemetry is not currently stored in this project.

## MITRE ATT&CK

Relevant contextual mappings include:

- T1059.001 — PowerShell
- T1110 — Brute Force

These mappings describe the simulated detection scenarios and are not attribution claims.

## Remediation

Recommended production controls include:

- Centralized Windows event collection
- Sysmon deployment
- PowerShell logging
- Endpoint detection and response
- Alert correlation
- Least privilege
- Authentication monitoring
- Process and command-line telemetry

## Validation

Offline validation is performed by `Scripts/offline_endpoint_validator.py`.

A future live validation should reproduce equivalent events on an authorized Windows test endpoint with Sysmon installed and compare the live telemetry with these expected detections.

## Lessons Learned

Endpoint detection engineering requires deterministic test cases, expected outcomes, telemetry context, and negative testing.

The distinction between synthetic validation and live endpoint evidence must remain explicit.

## Recommendations

The next phase should connect an authorized Windows test endpoint to Wazuh or another SIEM and repeat these detections using actual Sysmon Event IDs and Windows Event Logs.
