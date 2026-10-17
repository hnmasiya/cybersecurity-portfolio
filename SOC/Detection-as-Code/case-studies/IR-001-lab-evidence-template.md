# IR-001 — Lab Validation Evidence Record

**Status:** TEMPLATE — NOT YET EXECUTED  
**Required distinction:** Synthetic CI tests and authorized lab telemetry are separate evidence states.

## Execution details

- Test ID: IR-001-LAB
- Execution date/time UTC: Pending
- Operator / authorization: Pending
- Endpoint OS and build: Pending
- Sysmon version and configuration hash: Pending
- Repository commit / DE-001 version: Pending
- Collection window UTC: Pending
- Local manifest SHA-256: Pending (retain full raw bundle locally)

## Observed telemetry

| Source | Event ID | Expected | Observed | Notes |
|---|---:|---|---|---|
| Sysmon Operational | 1 | Child PowerShell process | Pending | Confirm image, command line, parent image |
| Windows Security | 4688 | Process creation if auditing enabled | Pending | Field shape differs from Sysmon |
| Sysmon Operational | 3 | Loopback connection attempt if configured | Pending | No external destination is used |
| Sysmon Operational | 11 | Temp marker file creation | Pending | Remove marker after review |

## Detection outcome

- Expected DE-001 result: one alert for the benign encoded-command test event.
- Actual DE-001 result: Pending.
- Benign-control outcome: Pending.
- Event-to-normalized-field mapping reviewed: Pending.
- False positives and collection gaps: Pending.
- Analyst conclusion: Pending.

## Acceptance criteria

- [ ] Test executed on an authorized Windows lab endpoint.
- [ ] Original evidence retained locally and SHA-256 manifest verified.
- [ ] Captured event IDs, UTC timestamps, process image, command line, parent process, host, and user reviewed.
- [ ] DE-001 expected/actual result recorded.
- [ ] Sysmon Event IDs 3 and 11 presence/absence explained.
- [ ] Sanitized evidence reviewed for personal, organizational, and infrastructure data.
- [ ] Public report updated without raw logs or secrets.

Do not mark this case as live-lab validated until the checklist is complete. Do not describe the lab result as production validation.
