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
| Active Directory Detection | Complete | Validated against both synthetic fixtures and 409 real events from a live Azure DC (see Azure Windows Server Lab evidence) |
| Linux Host Hardening | Complete | Offline/synthetic; live host pending |
| Container Configuration Audit | Complete | Offline/synthetic; live Docker host pending |
| Azure Windows Server Lab (IaC) | Complete | Deployed, hardened, and validated end-to-end: real Security event log exported and fed into the AD Detection Lab analyzer |
| Nmap | Evidence-Bounded | Live execution evidence pending |
| Wireshark | Evidence-Bounded | Live execution evidence pending |
| AppSec/SAST, Offensive Security, Enterprise AD Audit, Cloud CSPM | Methodology | Illustrative write-ups, not live findings |

## Remaining External Dependency
Windows + Sysmon + Wazuh Agent + live telemetry + live screenshots require access to a Windows endpoint. [`Cloud-Security/Azure-Windows-Server-Lab`](./Cloud-Security/Azure-Windows-Server-Lab/README.md) provides that endpoint — a real, deployed Azure Domain Controller, with its real Security event log already exported and validated against `ad_security_event_analyzer.py` (see its `Evidence/` folder). Installing Sysmon and a Wazuh Agent on the same VM is the remaining step to close the Wazuh-specific portion of this gap.
