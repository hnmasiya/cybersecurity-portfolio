# Endpoint-to-SIEM Correlation Validation

**Evidence state:** IMPLEMENTATION PLAN; execution evidence must be added after running in an authorized lab.

## Objective

Validate whether endpoint process telemetry is collected, parsed and searchable in the SIEM, then determine whether a selected process detection can be correlated with host and user context.

## Required evidence

- Endpoint product and version, collection policy and enabled telemetry.
- Host/agent identifier and time synchronization status.
- A benign control event and an approved synthetic test event.
- Raw endpoint event, parsed SIEM event and query result with timestamps.
- Field mapping for host, user, process image, command line, parent image and event time.
- Any ingestion delay, dropped events, parsing errors or coverage exclusions.

## Validation sequence

1. Confirm the endpoint and SIEM are owned or explicitly authorized for testing.
2. Generate a benign test process event; capture the source event and confirm it reaches the SIEM.
3. Run the documented query against the expected index or data view.
4. Compare raw and parsed fields, timestamps, host identity and user identity.
5. Test one approved suspicious-pattern fixture in a disposable lab; do not execute harmful payloads.
6. Verify the detection result and attach the rule ID, query, test case and actual output.
7. Record telemetry gaps and tune the collection configuration or field mapping.
8. Repeat the benign control to confirm that the change has not created broad noise.

## Product boundaries

This checklist can be used with a properly licensed endpoint platform such as Microsoft Defender for Endpoint or Sophos, subject to available telemetry and permissions. It does not claim that either platform is currently connected to this repository or that a live integration has been completed.

## Evidence table

| Evidence | Status |
|---|---|
| Endpoint event captured | Pending |
| SIEM event searchable | Pending |
| Required fields mapped | Pending |
| Detection result retained | Pending |
| Benign control checked | Pending |
| Telemetry limitations documented | Pending |

Do not claim EDR/XDR integration until a real authorized data path has been configured and validated.
