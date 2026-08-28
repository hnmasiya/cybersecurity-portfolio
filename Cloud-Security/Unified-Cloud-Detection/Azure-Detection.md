# Azure Detection

## Existing evidence

The Azure Windows Server lab provides a real deployed Windows Server 2022 environment with:
- Active Directory
- Sysmon
- Wazuh
- Windows Security events
- endpoint detection analysis
- hardening evidence
- Azure infrastructure evidence

## SOC workflow

**Azure infrastructure → Windows telemetry → Sysmon → Wazuh → detection → investigation → ATT&CK → response**

## Security controls

The existing Terraform implementation demonstrates:
- restricted RDP source
- default-deny inbound network policy
- no committed secrets
- controlled administrative access
- auto-shutdown
- small lab-oriented VM sizing

## Evidence

See: `../Azure-Windows-Server-Lab/Evidence/`

## Status

Deployment and telemetry evidence are retained.

Additional Azure-native Sentinel/Defender execution is not claimed unless corresponding evidence is added.
