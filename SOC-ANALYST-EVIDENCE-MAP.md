# SOC Analyst Evidence Map

This document maps practical SOC capabilities to specific repository evidence.

| SOC Capability | Evidence |
|---|---|
| SIEM Monitoring | `SIEM/Wazuh/` |
| Detection Engineering | `SIEM/Wazuh/Detection-Engineering-Lab/` and `Offensive-Security/Attack-Simulation-Detection-Lab/` |
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
| MITRE ATT&CK | Detection, enrichment, threat-hunting and attack-simulation projects |
| Evidence Handling | JSON, CSV, PCAP and investigation reports |
| Network Reconnaissance | `Network-Security/Nmap/` |
| Packet Analysis | `Network-Security/Wireshark/` and PCAP lab |
| Static Application Security Testing | `AppSec-DevSecOps/SAST-Reports/` |
| Cloud Landing Zone Architecture | `Cloud-Security/GCP-Landing-Zone-Lab/` |
| Attack Simulation & Detection Engineering | `Offensive-Security/Attack-Simulation-Detection-Lab/` |

## Evidence Classification

**Live:** Wazuh server deployment, now with a live, connected Windows endpoint. Azure Windows Server Lab (`Cloud-Security/Azure-Windows-Server-Lab/`) is a real, deployed Windows Server 2022 Domain Controller in Azure, hardened per its audit-policy baseline, with 409 real Security events exported and analyzed (392 findings), real Sysmon telemetry (16 events, 5 findings) captured after installing Sysmon with the SwiftOnSecurity configuration, and its Wazuh Agent connected to the project's Wazuh Manager over a Tailscale mesh VPN, generating real MITRE-mapped alerts and CIS Benchmark SCA findings. Linux Host Hardening Lab (`Linux-Security/Hardening-Lab/`) is validated against a real personal Linux host. Container Configuration Audit Lab (`Docker-Labs/Container-Audit-Lab/`) is validated against a real home-lab Docker host. Nmap (`Network-Security/Nmap/`) is a real full-TCP-range scan against the same self-owned home-lab host. Wireshark (`Network-Security/Wireshark/`) contains a real packet capture of the project's own Juice Shop traffic. AppSec/SAST (`AppSec-DevSecOps/SAST-Reports/`) contains a real Bandit scan of this portfolio's own Python codebase.

**Controlled laboratory:** DVWA, Juice Shop and controlled security-validation exercises.

**Synthetic/offline:** Threat Hunting validation.

**Architecture / not yet deployed:** GCP Secure Landing Zone (`Cloud-Security/GCP-Landing-Zone-Lab/`) — real, formatting-checked Terraform with documented organization guardrails, environment structure, Shared VPC and centralized logging design. `terraform validate`/`plan`/`apply` remain pending access to a real GCP organization and provider registry connectivity.

**Live attack simulation validation — 6 of 6 combinations evidence-backed:** Attack Simulation & Detection Engineering Lab (`Offensive-Security/Attack-Simulation-Detection-Lab/`) validates 3 MITRE ATT&CK technique areas across 2 self-owned platforms: the home-lab Linux host and the Azure Windows Server 2022 Domain Controller. All 6 Linux/Windows technique combinations have been executed against live targets and have corresponding timestamped Wazuh alert evidence preserved in the lab's `Evidence/` directory. The validated technique areas include Execution (T1059), Persistence (T1053/T1547), and Credential Access (T1003). The project documents the attack → telemetry → detection rule → Wazuh alert → validation workflow, including false-positive analysis, rule precedence, telemetry gaps, agent-state issues, cleanup and deployment validation. Credential-access testing is bounded to safe detection validation and does not claim successful credential extraction.

**Illustrative scenario (not a live finding):** the Enterprise AD hygiene report is a scenario write-up demonstrating reporting methodology, labeled as such at the top of the file. It is not evidence of a real-world enterprise finding.

## Live Windows Endpoint → Wazuh Chain

This chain is closed end-to-end:

`Windows → Sysmon → Wazuh Agent → Wazuh Manager → live alert`

`Cloud-Security/Azure-Windows-Server-Lab/` provides the Windows endpoint — a deployed Azure Domain Controller, with real Security event data exported and analyzed, Sysmon telemetry captured and analyzed, and its Wazuh Agent connected to the project's Wazuh Manager (`SIEM/Wazuh/`, Docker on a home machine) over a private Tailscale mesh VPN. Wazuh's rule engine has generated real alerts from this connection, including MITRE-mapped authentication activity and CIS Microsoft Windows Server 2022 Benchmark SCA findings. See the lab's `Evidence/` folder for the retained exports, analyses and connection evidence.

## Evidence Integrity Rule

The portfolio distinguishes between observed/live evidence, controlled laboratory activity, synthetic/offline validation and architecture/methodology. Counts, timestamps, alerts, incidents and outcomes are only presented as observed when supported by retained artifacts. Controlled tests are not represented as professional employment experience or real-world breaches.
