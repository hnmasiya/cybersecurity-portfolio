# Linux Host Hardening Audit Lab

This project demonstrates an offline Linux host hardening audit using a
synthetic configuration snapshot, evaluated against CIS-benchmark-style
rules.

## Checks

- SSH root login permitted / password authentication enabled / legacy
  protocol version
- Unrestricted passwordless sudo (`NOPASSWD` on `ALL` commands)
- World-writable files outside `/tmp`
- SUID binaries not on the expected allowlist
- Legacy/insecure services running (telnet, rsh, rlogin, tftp, ...)
- Host firewall inactive

## Validation

Run:

`python3 Scripts/linux_hardening_auditor.py --input Data/synthetic-host-snapshot.json --output Evidence/hardening-audit.json`

Results are written to `Evidence/hardening-audit.json`.

## Current status

**Offline / synthetic validation.**

Live host telemetry is not currently claimed as evidence. The synthetic
snapshot includes both misconfigurations and correctly-hardened settings
(a scoped `NOPASSWD` sudo entry, allowlisted SUID binaries, files under
`/tmp`) to demonstrate the audit logic doesn't flag ordinary, compliant
configuration.
