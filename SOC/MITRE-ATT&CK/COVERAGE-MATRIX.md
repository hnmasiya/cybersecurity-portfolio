# MITRE ATT&CK Coverage Matrix

| Technique | Area | Evidence source | Status |
|---|---|---|---|
| T1059.001 PowerShell | Endpoint | Azure/Sysmon evidence | OBSERVED where telemetry supports it |
| T1078 Valid Accounts | Windows/Wazuh | Wazuh evidence | OBSERVED where retained alert supports it |
| Account manipulation | AD | Azure/AD evidence | Context-dependent |
| Network communication | Endpoint | Sysmon Event ID 3 | OBSERVED where retained telemetry supports it |
| Cloud account/IAM activity | Cloud | GCP/Azure audit evidence | Evidence-dependent |
| Credential access | Endpoint | Investigation methodology | PENDING unless evidenced |
| Lateral movement | Endpoint | Investigation methodology | PENDING unless evidenced |
| Command and control | Endpoint | Investigation methodology | PENDING unless evidenced |

## Coverage rule

The matrix is intentionally conservative.

Absence of evidence is not converted into an attacker narrative.
