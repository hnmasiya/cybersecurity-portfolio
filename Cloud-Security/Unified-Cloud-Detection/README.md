# Unified Cloud Detection & Response

## Purpose

This project unifies the portfolio's existing Azure and GCP security work into a SOC-oriented detection lifecycle.

## Workflow

```
Cloud activity
      |
      v
Audit / security telemetry
      |
      v
Detection
      |
      v
Alert
      |
      v
Triage
      |
      v
Investigation
      |
      v
MITRE ATT&CK
      |
      v
Remediation
      |
      v
Verification
```

## Azure

Existing evidence includes:
- Windows Server 2022
- Active Directory
- Sysmon
- Wazuh
- security event telemetry
- endpoint detection
- Terraform
- hardening
- network security controls

See: `../Azure-Windows-Server-Lab/`

## GCP

Existing security work includes:
- project security
- IAM
- CSPM auditing
- Terraform
- security configuration collection
- cloud detection logic

See: `../GCP-Project-Security-Lab/` and `../GCP-Landing-Zone-Lab/`

## Detection scenarios

### IAM modification
Investigate:
- privileged role changes
- new administrative identities
- policy modifications
- service-account changes

### Public exposure
Investigate:
- publicly accessible resources
- permissive firewall rules
- storage exposure
- unnecessary network paths

### Security-control changes
Investigate:
- logging changes
- monitoring changes
- security policy changes
- IAM policy modifications

### Suspicious administration
Investigate:
- unusual administrative identities
- unusual source locations
- unexpected privileged operations
- service-account activity

## Evidence status

Only existing retained artifacts are described as observed.

New scenarios remain:
**PENDING LIVE VALIDATION**

unless execution evidence is added.
