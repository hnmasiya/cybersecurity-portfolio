# Windows / Sysmon Endpoint Detection Lab

This project validates Windows endpoint detection logic using synthetic Windows and Sysmon-style events.

## Current status

**Complete — validated against both synthetic and real data**

The detection logic (`Scripts/offline_endpoint_validator.py`'s `detect()` function) has been validated two ways: a synthetic self-test with pre-labeled expected outcomes, and a run against real Sysmon telemetry captured from a live, domain-joined Windows Server (see [Azure Windows Server Lab](../../Cloud-Security/Azure-Windows-Server-Lab/README.md)).

## Detection scenarios

- Suspicious PowerShell
- PowerShell network connection
- Failed Windows authentication
- PowerShell child process

## Validation (synthetic)

Run:

`python3 Scripts/offline_endpoint_validator.py`

The validator produces:

`Evidence/detection-validation.json`

## Real telemetry

Sysmon (installed with the SwiftOnSecurity community configuration) and Windows Security event data were captured directly from the live Domain Controller and analyzed with the same detection logic via a real-data analyzer (no pre-labeled ground truth, findings reported as-is):

`python3 Scripts/real_endpoint_event_analyzer.py --input ../Cloud-Security/Azure-Windows-Server-Lab/Evidence/raw-sysmon-events.json --output ../Cloud-Security/Azure-Windows-Server-Lab/Evidence/real-sysmon-analysis.json`

Result: 16 events analyzed, 5 findings (0 high, 5 medium):

- **EDR-004** ×1 — `notepad.exe` spawned by `powershell.exe`: a deliberate test process launch during the session, not an intrusion.
- **EDR-002** ×3 — `powershell.exe` connecting out on port 443: these are the session's own `Invoke-WebRequest` calls downloading Sysmon and its configuration from GitHub/Sysinternals.
- **EDR-003** ×1 — one failed logon (4625), the same event already captured and explained in the AD Detection Lab's real data.

No genuinely malicious activity was present in this capture; the findings correctly reflect real, explainable activity on the box, which is the honest result to expect from a lab environment.

## Remaining gap

A Wazuh Agent has not been installed or connected to a Wazuh Manager from this endpoint. The project's Wazuh Manager runs locally via Docker on a home machine, and connecting a cloud VM to it would require exposing a home-network port — a tradeoff deliberately not made yet. Sysmon telemetry capture and analysis is complete independent of that connection.
