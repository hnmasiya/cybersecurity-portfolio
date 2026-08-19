# Wazuh Detection Engineering Lab

This project validates custom Wazuh authentication rules offline.

## Rules

- `100001` — authentication rule dependent on parent SID `5710`
- `100002` — suspicious login rule matching `Failed password`

## Validation

A Python harness evaluates controlled authentication events against the XML rule conditions.

## Limitation

Wazuh Manager is not installed on this workstation. This is offline rule validation, not live Wazuh alert evidence.

## Evidence

See the `Evidence/` directory for JSON and CSV validation output.
