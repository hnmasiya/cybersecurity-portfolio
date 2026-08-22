# Threat Hunting & Detection Validation Lab

This project demonstrates an offline threat-hunting workflow using synthetic authentication and endpoint telemetry.

## Hunts

- Repeated failed authentication
- Encoded PowerShell
- PowerShell network activity

## Validation

Run:

`python3 Scripts/offline_hunt_validator.py`

Results are written to `Evidence/hunt-validation.json` and `Evidence/hunt-validation.csv`.

## Current status

**Offline / synthetic validation.**

Live enterprise endpoint telemetry is not currently claimed as evidence.
