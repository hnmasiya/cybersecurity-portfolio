# Cybersecurity Lab Completion Tracker

| Lab | Status | Limitation |
|---|---|---|
| DVWA | Complete | None |
| OWASP Juice Shop | Complete | None |
| PCAP Monitoring | Complete | Synthetic lab |
| Wazuh | Complete | Live server with a live, connected Windows endpoint (Azure DC via Tailscale mesh VPN); real MITRE-mapped alerts and CIS Benchmark SCA findings generated |
| Security Automation | Complete | Local/sample validation |
| Windows / Sysmon | Complete | Validated against both synthetic fixtures and 16 real Sysmon/Security events from a live Azure DC (see Azure Windows Server Lab evidence) |
| Threat Hunting | Complete | Offline/synthetic |
| Incident Response | Complete | Evidence-driven lab |
| Active Directory Detection | Complete | Validated against both synthetic fixtures and 409 real events from a live Azure DC (see Azure Windows Server Lab evidence) |
| Linux Host Hardening | Complete | Validated against both synthetic fixtures and a real, live personal host (0 findings, all 26 SUID binaries individually package-verified) |
| Container Configuration Audit | Complete | Validated against both synthetic fixtures and a real, live Docker host (14 findings across 8 containers: hardcoded secrets, root containers, a docker.sock mount, unpinned tags) |
| Azure Windows Server Lab (IaC) | Complete | Deployed, hardened, and validated end-to-end: real Security event log exported and fed into the AD Detection Lab analyzer |
| Nmap | Evidence-Bounded | Live execution evidence pending |
| Wireshark | Evidence-Bounded | Live execution evidence pending |
| AppSec/SAST, Offensive Security, Enterprise AD Audit, Cloud CSPM | Methodology | Illustrative write-ups, not live findings |

## Live Windows Endpoint
[`Cloud-Security/Azure-Windows-Server-Lab`](./Cloud-Security/Azure-Windows-Server-Lab/README.md) provides a real, deployed Azure Domain Controller, fully validated end-to-end: its real Security event log is exported and analyzed against `ad_security_event_analyzer.py`, Sysmon (SwiftOnSecurity config) captures real telemetry analyzed against the Windows/Sysmon Endpoint Detection Lab's logic, and its Wazuh Agent is connected to the project's Wazuh Manager over a Tailscale mesh VPN, generating real Wazuh-side alerts (MITRE-mapped detections, CIS Benchmark SCA findings). See its `Evidence/` folder for all three.

## Remaining Gaps
Live execution evidence is still pending for Nmap and Wireshark — this doesn't block on the work above.
