# Windows / Sysmon Endpoint Detection Lab

This project validates Windows endpoint detection logic using synthetic Windows and Sysmon-style events.

## Current status

**Offline detection engineering / synthetic validation**

A live Windows endpoint with Sysmon is not currently part of the stored repository evidence.

## Detection scenarios

- Suspicious PowerShell
- PowerShell network connection
- Failed Windows authentication
- PowerShell child process

## Validation

Run:

`python3 Scripts/offline_endpoint_validator.py`

The validator produces:

`Evidence/detection-validation.json`

## Next phase

Repeat the same scenarios against an authorized Windows test endpoint with Sysmon and centralized SIEM collection.
