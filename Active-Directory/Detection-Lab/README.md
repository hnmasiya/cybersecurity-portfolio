# Active Directory Security Event Detection Lab

This project demonstrates an Active Directory security-event analysis
workflow, validated against both synthetic Windows Security event log
records and real telemetry from a live Azure Domain Controller.

## Detections

- Brute Force Authentication Attempt (repeated Event ID 4625 for one account)
- Kerberos Pre-Authentication Failure Burst (repeated Event ID 4771)
- Possible Kerberoasting Activity (multiple RC4-encrypted TGS requests for
  distinct SPNs — Event ID 4769)
- Privileged Group Membership Change (Event ID 4728 / 4732 / 4756)
- New User Account Created (Event ID 4720)
- Special Privileges Assigned to New Logon (Event ID 4672)
- Security Audit Log Cleared (Event ID 1102)

Each finding is mapped to MITRE ATT&CK.

## Validation

**Synthetic:**

`python3 Scripts/ad_security_event_analyzer.py --input Data/synthetic-ad-events.json --output Evidence/ad-analysis.json`

Results are written to `Evidence/ad-analysis.json`.

**Real telemetry:**

`python3 Scripts/ad_security_event_analyzer.py --input ../../Cloud-Security/Azure-Windows-Server-Lab/Evidence/raw-security-events.json --output ../../Cloud-Security/Azure-Windows-Server-Lab/Evidence/real-ad-analysis.json`

409 real Windows Security events exported from a live Azure Domain
Controller ([`Cloud-Security/Azure-Windows-Server-Lab`](../../Cloud-Security/Azure-Windows-Server-Lab/README.md))
via `Export-SecurityEventLog.ps1`, producing 392 findings (1 CRITICAL, 16
HIGH, 375 MEDIUM) — see that lab's README for the full breakdown and honest
interpretation of what those findings actually mean (mostly legitimate
administrative/service activity, correctly flagged but not an intrusion).

## Current status

**Complete — validated against both synthetic and real data.**

The synthetic dataset includes benign noise (single failed logons, non-RC4
service ticket requests) alongside the attack patterns above, to demonstrate
the detection logic does not fire on ordinary activity. The real dataset
demonstrates the same logic running against actual Windows Security
telemetry from a deployed Domain Controller, including correctly-flagged
findings that turned out to be authorized administrative activity on
investigation — a realistic SOC triage scenario, not a cherry-picked clean
result.
