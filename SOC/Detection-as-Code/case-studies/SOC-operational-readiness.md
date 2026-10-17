# SOC Operational Readiness — Evidence Gates

**Current state:** CI-backed synthetic exercises exist. Live Windows/Sysmon and SIEM validation must be recorded separately after an authorized run.

| Workstream | Existing foundation | Remaining acceptance evidence |
|---|---|---|
| Live endpoint telemetry | IR-001 synthetic timeline and local collection script | Actual event IDs, field mapping, test result, local hash manifest, reviewed sanitized summary |
| Detection engineering | DE-001/002/003 harness, Sigma validation, regression tests | Tuning based on actual telemetry; false-positive rationale and rule version |
| Incident response | IR-001 tabletop and lifecycle playbook | Analyst-reviewed triage record and decision log from lab exercise |
| Correlation | Host/user/time-window event correlation | Field mappings and edge-case results against collected lab events |
| Authentication | Broader identity telemetry is planned | Authorized 4624/4625 sample, account/host normalization, benign controls |
| Automation | Offline enrichment and recommendation workflows | Explicit approval record; dry-run evidence; no unapproved containment |
| Governance | CI and synthetic reports | Owner, review date, severity rationale, version, validation state, exception/rollback notes |

## Response decision contract

The automation may:
- Normalize evidence and add context.
- Produce a timeline, confidence limitations, and recommended analyst actions.
- Mark required approvals and log a decision.

The automation must not autonomously:
- Disable users or reset credentials.
- Isolate endpoints or change firewall rules.
- Kill processes or delete files.
- Submit external indicators or upload evidence to third parties.

Any future response integration must have a separate authorized design, dry-run mode, human approval, audit logging, least privilege, and rollback procedure.

## Evidence labels

Use exactly one label per claim:
- **SYNTHETIC:** hand-authored fixtures or simulated output.
- **OFFLINE VALIDATION:** code and tests executed without a live endpoint/SIEM.
- **LAB VALIDATED:** authorized endpoint telemetry was collected and reviewed.
- **SIEM VALIDATED:** ingestion and detection were verified in the actual SIEM.
- **PRODUCTION VALIDATED:** formally approved production test with retained evidence and scope.

Do not promote a claim to a stronger evidence state merely because CI passed.
