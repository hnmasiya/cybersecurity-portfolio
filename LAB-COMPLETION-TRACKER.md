# Cybersecurity Lab Completion Tracker

| Lab | Status | Limitation |
|---|---|---|
| DVWA | Complete | None |
| OWASP Juice Shop | Complete | None |
| PCAP Monitoring | Complete | Synthetic lab |
| Wazuh | Complete | Live server; no Windows endpoint |
| Security Automation | Complete | Local/sample validation |
| Windows / Sysmon | Complete | Live endpoint pending |
| Threat Hunting | Complete | Offline/synthetic |
| Incident Response | Complete | Evidence-driven lab |
| Active Directory Detection | Complete | Offline/synthetic; live DC pending |
| Linux Host Hardening | Complete | Offline/synthetic; live host pending |
| Container Configuration Audit | Complete | Offline/synthetic; live Docker host pending |
| Azure Windows Server Lab (IaC) | Infrastructure-as-Code Written | Terraform + PowerShell written; not yet deployed |
| Nmap | Evidence-Bounded | Live execution evidence pending |
| Wireshark | Evidence-Bounded | Live execution evidence pending |
| AppSec/SAST, Offensive Security, Enterprise AD Audit, Cloud CSPM | Methodology | Illustrative write-ups, not live findings |

## Remaining External Dependency
Windows + Sysmon + Wazuh Agent + live telemetry + live screenshots require access to a Windows endpoint. [`Cloud-Security/Azure-Windows-Server-Lab`](./Cloud-Security/Azure-Windows-Server-Lab/README.md) provides the Terraform/PowerShell to stand one up in Azure on demand; once deployed, it also closes the "live DC pending" gap on the Active Directory Detection lab above.
