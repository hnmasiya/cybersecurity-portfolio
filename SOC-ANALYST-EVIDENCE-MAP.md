# SOC Analyst Evidence Map

This document maps practical SOC capabilities to specific repository evidence.

| SOC Capability | Evidence |
|---|---|
| SIEM Monitoring | `SIEM/Wazuh/` |
| Detection Engineering | `SIEM/Wazuh/Detection-Engineering-Lab/` |
| Alert Triage | `Security-Automation/SOC-Alert-Triage/` |
| IOC Extraction | `Security-Automation/Wazuh-Alert-Enrichment/` |
| Threat Hunting | `Threat-Hunting/Detection-Validation-Lab/` |
| Active Directory Security | `Active-Directory/Detection-Lab/` |
| Linux Host Hardening | `Linux-Security/Hardening-Lab/` |
| Container Security | `Docker-Labs/Container-Audit-Lab/` |
| Incident Response | `Incident-Response/` and Wazuh investigation reports |
| Network Security Monitoring | `Network-Security/PCAP-Analysis/` |
| Web Application Security | `Web-Security/DVWA/` |
| OWASP Testing | `Web-Security/Juice-Shop/` |
| Endpoint Detection | `Endpoint-Security/Windows-Sysmon-Detection-Lab/` |
| Python Automation | `Security-Automation/`, endpoint and hunt validators |
| Bash Automation | `Security-Automation/Bash/` |
| MITRE ATT&CK | Detection, enrichment and threat-hunting projects |
| Evidence Handling | JSON, CSV, PCAP and investigation reports |
| Network Reconnaissance | `Network-Security/Nmap/` |
| Packet Analysis | `Network-Security/Wireshark/` and PCAP lab |

## Evidence Classification

**Live:** Wazuh server deployment. Azure Windows Server Lab (`Cloud-Security/Azure-Windows-Server-Lab/`) — a real, deployed Windows Server 2022 Domain Controller in Azure, hardened per its audit-policy baseline, with 409 real Security events exported and analyzed (392 findings — see its `Evidence/` folder).

**Controlled laboratory:** DVWA, Juice Shop and PCAP exercises.

**Synthetic/offline:** Windows/Sysmon detection, Threat Hunting validation,
Active Directory Detection Lab, Linux Host Hardening Lab, and Container
Configuration Audit Lab.

**Evidence-bounded methodology:** Nmap and Wireshark active methodology reports.

**Illustrative scenario (not a live finding):** the AppSec/SAST,
Offensive Security, Enterprise AD hygiene, and Cloud CSPM reports are
scenario write-ups demonstrating reporting methodology - each is
labeled as such at the top of the file, with a pointer to the nearest
evidence-backed equivalent where one exists.

## Remaining Live Dependency

The remaining live endpoint capability is:

`Windows -> Sysmon -> Wazuh Agent -> Wazuh Manager -> live alert`

`Cloud-Security/Azure-Windows-Server-Lab/` provides that Windows endpoint —
a deployed Azure Domain Controller, with its real Security event log already
exported and run through `Active-Directory/Detection-Lab/Scripts/
ad_security_event_analyzer.py` (see its `Evidence/` folder for the raw
export and the 392-finding analysis). Installing Sysmon and a Wazuh Agent on
the same VM is the remaining step to close the Wazuh-specific portion of
this gap.
