# GCP Detection

## Existing portfolio evidence

The GCP security portfolio includes:
- project security assessment
- IAM policy analysis
- CSPM auditing
- Terraform infrastructure
- configuration collection
- detection logic

## SOC model

```
GCP activity
    |
    v
Cloud audit/configuration telemetry
    |
    v
Security detection
    |
    v
Analyst triage
    |
    v
IAM / resource investigation
    |
    v
Remediation
    |
    v
Verification
```

## Detection candidates

- privileged IAM modifications
- excessive permissions
- public resource exposure
- service-account changes
- security-control modifications

## Evidence integrity

Only executed and retained GCP artifacts are described as observed.

Unexecuted detection scenarios remain:
**PENDING LIVE VALIDATION**
