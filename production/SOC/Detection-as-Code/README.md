# Detection as Code

This area documents the portfolio's detection engineering work in a repeatable format.

## Current workflow

**Detection concept → detection logic → Wazuh implementation → test event → expected result → actual result → tuning**

## Each detection should contain

- Name
- Purpose
- Data source
- Event ID/log source
- Detection logic
- Severity
- ATT&CK mapping
- False-positive considerations
- Validation status
- Tuning notes

Do not claim Sigma compatibility, conversion or successful testing unless demonstrated by repository evidence.
