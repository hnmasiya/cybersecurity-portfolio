# Cloud Detection — Offline Validation Record

**Evidence state: OFFLINE VALIDATION**

## Scenario
Detect IAM policy modification events in a synthetic Google Cloud Audit Log dataset.

## Detection
The detector matches `protoPayload.methodName` values ending in `SetIAMPolicy`.

Google Cloud documents Admin Activity audit logs as recording user-driven API calls that modify resource configuration or metadata, including IAM permission changes. Google also documents `SetIamPolicy` as an IAM audit-log method. citeturn0search8turn0search9

## Evidence
The retained synthetic dataset contains two `SetIAMPolicy` events and one unrelated Compute Engine instance-creation event.

## Result
**2 IAM policy modification events detected; 1 unrelated event ignored.**

The detection result is an offline validation result, not live cloud telemetry.

## Limitations
No GCP project was queried or modified. No live alerting, Cloud Logging sink, SIEM integration or remediation was executed.

## Next live step
Run the same detector against an authorized exported Cloud Audit Log dataset or controlled GCP environment and retain the original telemetry plus validation output.
