# Active Directory Security Event Detection Lab

This project demonstrates an offline Active Directory security-event analysis
workflow using synthetic Windows Security event log records.

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

Run:

`python3 Scripts/ad_security_event_analyzer.py --input Data/synthetic-ad-events.json --output Evidence/ad-analysis.json`

Results are written to `Evidence/ad-analysis.json`.

## Current status

**Offline / synthetic validation.**

Live Active Directory domain telemetry is not currently claimed as evidence.
The synthetic dataset includes benign noise (single failed logons, non-RC4
service ticket requests) alongside the attack patterns above, to demonstrate
the detection logic does not fire on ordinary activity.
