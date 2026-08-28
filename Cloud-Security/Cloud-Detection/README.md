# Cloud Detection

This extends the existing cloud-security work toward SOC operations rather than creating another generic cloud architecture project.

## Workflow

**Cloud activity → audit log → detection → alert → investigation → remediation → verification**

## Candidate scenarios

- IAM changes
- excessive permissions
- public exposure
- security-control changes
- suspicious administrative activity
- service-account changes

Use existing Azure/GCP evidence where available.

Unexecuted scenarios must be labelled **PENDING LIVE VALIDATION**.
