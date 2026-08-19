# Proactive Threat Hunting & Detection Validation

This directory contains structured threat-hunting methodology and an evidence-driven offline detection-validation lab.

## Current lab status

The active threat-hunting validation project uses synthetic authentication and endpoint telemetry. It is clearly separated from live enterprise telemetry.

## Hunt scenarios

- Repeated failed authentication
- Encoded PowerShell
- PowerShell network activity

## Evidence

The active validation lab contains:

- Synthetic hunt events
- Hunt logic
- JSON validation results
- CSV validation results
- Python validation tooling
- MITRE ATT&CK contextual mappings

[View Threat Hunting Detection Validation](./Detection-Validation-Lab/README.md)

## Methodology

Threat hunting remains hypothesis-driven:

1. Define a hunt hypothesis.
2. Identify required telemetry.
3. Apply analytic logic.
4. Validate expected detections.
5. Correlate context.
6. Document findings.
7. Repeat the hunt against live authorized telemetry when available.

## Evidence standard

Synthetic activity is explicitly labelled as synthetic.

Specific real-world findings must only be reported when supported by stored telemetry or other repository evidence.
