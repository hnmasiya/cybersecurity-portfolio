# Cybersecurity Lab Completion Tracker

| Lab | Status | Limitation |
|---|---|---|
| DVWA | Complete | None |
| OWASP Juice Shop | Complete | None |
| PCAP Monitoring | Complete | Synthetic lab |
| Wazuh | Complete | Live server; Windows endpoint (Sysmon) captured, Agent-to-Manager connection deferred by choice (would expose home network) |
| Security Automation | Complete | Local/sample validation |
| Windows / Sysmon | Complete | Validated against both synthetic fixtures and 16 real Sysmon/Security events from a live Azure DC (see Azure Windows Server Lab evidence) |
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
[`Cloud-Security/Azure-Windows-Server-Lab`](./Cloud-Security/Azure-Windows-Server-Lab/README.md) provides a real, deployed Azure Domain Controller. Its real Security event log has been exported and validated against `ad_security_event_analyzer.py`, and Sysmon has been installed (SwiftOnSecurity config) with real telemetry exported and validated against the Windows/Sysmon Endpoint Detection Lab's detection logic (see its `Evidence/` folder for both). The one remaining gap is connecting a Wazuh Agent on that VM to a Wazuh Manager: the project's Manager runs locally via Docker on a home machine, and wiring a cloud VM to it would mean exposing a home-network port — deliberately deferred rather than done blindly.
