# SOC Automation — Controlled Execution Record

**Evidence state: CONTROLLED / SYNTHETIC**

## Scenario
Run the existing SOC alert-triage logic against a retained synthetic alert set.

## Workflow exercised
Alert/log → parse → IOC extraction → MITRE mapping → severity → priority → disposition → JSON output.

## Evidence
Input: `evidence/synthetic-alerts.json`
Output: `evidence/execution-output.json`

## Result
Three synthetic alerts were processed:
- 1 HIGH → P2 → ESCALATE
- 1 MEDIUM → P3 → INVESTIGATE
- 1 LOW → P4 → MONITOR

The HIGH alert extracted the documentation-only TEST-NET IP `198.51.100.23`; no external enrichment was performed.

## Validation
The output was reproduced offline from the retained input and existing triage logic.

## Limitations
No production SIEM feed, automated containment, external enrichment or measured operational time savings were used.

## Result
The project now has execution evidence for its core parsing/triage workflow while retaining a controlled/synthetic boundary.
