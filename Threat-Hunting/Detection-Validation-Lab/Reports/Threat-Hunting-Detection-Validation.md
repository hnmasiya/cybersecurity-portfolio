# Threat Hunting & Detection Validation Lab

## Objective

Demonstrate a repeatable threat-hunting workflow using synthetic authentication and endpoint telemetry, while clearly separating offline validation from live enterprise telemetry.

## Skills & Tools

- Threat hunting
- Windows authentication analysis
- Sysmon telemetry concepts
- PowerShell detection
- IOC extraction
- Detection engineering
- Python
- JSON and CSV evidence
- MITRE ATT&CK
- SOC triage
- Hypothesis-driven investigation

## Architecture

Synthetic authentication and endpoint events are processed by a deterministic Python hunting validator.

`Synthetic telemetry -> Hunt hypothesis -> Analytic logic -> Detection -> Validation evidence -> SOC triage`

## Topology

The project represents an analyst workstation querying authorized laboratory telemetry from a Windows endpoint dataset.

No real production endpoint or external target is involved.

## Execution

The lab evaluates three hunting hypotheses:

1. Repeated failed authentication indicating possible password-guessing activity.
2. Encoded PowerShell execution.
3. PowerShell network activity.

## Walkthrough

1. Load synthetic authentication and endpoint events.
2. Apply the suspicious-login hunt.
3. Aggregate failed logons by source IP.
4. Apply PowerShell hunting logic.
5. Review PowerShell network activity.
6. Record results as JSON and CSV.
7. Map relevant detections to MITRE ATT&CK.
8. Perform SOC-oriented interpretation.

## Attack Simulation

The dataset contains intentionally generated laboratory scenarios representing authentication abuse and suspicious PowerShell activity.

No real attacker activity is claimed.

## Detection

The hunting logic identifies:

- repeated Event ID `4625` failures;
- encoded PowerShell command execution;
- PowerShell network activity over TCP/443.

## Triage

A hunter should validate:

- source IP;
- targeted account;
- failure count;
- host;
- timestamps;
- process image;
- command line;
- destination;
- whether the activity is expected.

## Investigation

Authentication activity should be correlated with successful logons, endpoint process telemetry, network connections, account context, and known administrative behaviour.

## Evidence

- `Data/synthetic-hunt-events.json`
- `Queries/Suspicious-Login-Hunt.md`
- `Queries/hunt-rules.json`
- `Evidence/hunt-validation.json`
- `Evidence/hunt-validation.csv`
- `Scripts/offline_hunt_validator.py`

## Findings

The hunt successfully identifies the repeated failed-authentication scenario and the two PowerShell-related scenarios while leaving the benign successful-login event outside the hunt results.

## Impact

Repeated failed authentication can indicate password guessing or account targeting. Encoded PowerShell and unexpected PowerShell network activity can indicate suspicious execution or follow-on activity in a real enterprise environment.

No production compromise is claimed.

## Root Cause

This project is a controlled threat-hunting validation exercise.

The telemetry is synthetic because live endpoint and enterprise authentication telemetry is not currently stored in this project.

## MITRE ATT&CK

Contextual mappings:

- T1110 — Brute Force
- T1059.001 — PowerShell

These mappings describe the simulated hunting scenarios and are not attribution claims.

## Remediation

Production hunting should use:

- centralized authentication logs;
- endpoint telemetry;
- Sysmon;
- SIEM correlation;
- user and asset context;
- allow-lists;
- baseline behaviour;
- automated alert enrichment.

## Validation

Offline validation passed against the stored synthetic dataset.

Live hunting against a production or test Windows environment has not been claimed.

## Lessons Learned

Threat hunting is hypothesis-driven and benefits from deterministic test data, explicit analytic logic, negative testing, and repeatable evidence.

## Recommendations

The next phase should execute these same hunts against an authorized Windows/Sysmon endpoint and Wazuh or another SIEM, then compare live results with the synthetic baseline.
