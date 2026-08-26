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
| Active Directory Detection | Complete | Offline/synthetic; live DC now available (Azure Windows Server Lab), event export pipeline pending |
| Linux Host Hardening | Complete | Offline/synthetic; live host pending |
| Container Configuration Audit | Complete | Offline/synthetic; live Docker host pending |
| Azure Windows Server Lab (IaC) | Complete | Deployed and hardened; real Sysmon/event export to feed AD Detection Lab pending |
| Nmap | Evidence-Bounded | Live execution evidence pending |
| Wireshark | Evidence-Bounded | Live execution evidence pending |
| AppSec/SAST, Offensive Security, Enterprise AD Audit, Cloud CSPM | Methodology | Illustrative write-ups, not live findings |

## Remaining External Dependency
Windows + Sysmon + Wazuh Agent + live telemetry + live screenshots require access to a Windows endpoint. [`Cloud-Security/Azure-Windows-Server-Lab`](./Cloud-Security/Azure-Windows-Server-Lab/README.md) provides that endpoint — a real, deployed Azure Domain Controller (see its `Evidence/` folder). Exporting its real Security event log and reshaping it to feed `ad_security_event_analyzer.py` (closing the "live DC pending" gap above) is the remaining step.
