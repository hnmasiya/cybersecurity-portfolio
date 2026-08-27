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
| Nmap | Complete | Real full-TCP-range scan against a self-owned home-lab host (13 open ports, raw output preserved in 3 formats) |
| Wireshark | Complete | Real packet capture of Juice Shop traffic (52 packets), including a genuine SQLi-pattern test correctly flagged by the analyzer |
| AppSec/SAST | Complete | Real `bandit` scan of this portfolio's own codebase (1,278 lines, 37 scripts) — 1 real High-severity finding fixed, remaining Medium/Low findings triaged and documented (one confirmed false positive) |
| GCP Secure Landing Zone (IaC) | Architecture | Real Terraform (org policy guardrails, folder structure, Shared VPC, org-wide logging sink), formatting-checked; `validate`/`plan`/`apply` pending a real GCP org and registry access this environment lacks |
| OpenCTI Custom SOC Dashboard | Methodology | Design specified against OpenCTI's real STIX 2.1 data model and widget types; no live instance — this environment has no Docker daemon to run OpenCTI's stack |
| Offensive Security, Enterprise AD Audit, Cloud CSPM | Methodology | Illustrative write-ups, not live findings — no authorized pentest target, live AD domain, or cloud account accessible from this environment |

## Live Windows Endpoint
[`Cloud-Security/Azure-Windows-Server-Lab`](./Cloud-Security/Azure-Windows-Server-Lab/README.md) provides a real, deployed Azure Domain Controller, fully validated end-to-end: its real Security event log is exported and analyzed against `ad_security_event_analyzer.py`, Sysmon (SwiftOnSecurity config) captures real telemetry analyzed against the Windows/Sysmon Endpoint Detection Lab's logic, and its Wazuh Agent is connected to the project's Wazuh Manager over a Tailscale mesh VPN, generating real Wazuh-side alerts (MITRE-mapped detections, CIS Benchmark SCA findings). See its `Evidence/` folder for all three.

## Remaining Gaps
Offensive Security, Enterprise AD Audit, and Cloud CSPM remain intentionally-illustrative Methodology write-ups — each would need an authorized live pentest target, a real Active Directory domain, and a real cloud account respectively, none of which are stand-ins for what's already evidence-backed elsewhere in this repo (the AD Detection Lab's real event analysis, the Azure Windows Server Lab's real domain controller). Every other lab, including AppSec/SAST as of this pass, is validated against real, live evidence rather than synthetic fixtures alone. The GCP Secure Landing Zone is real Terraform pending deployment (same starting point the Azure lab had before it was applied), and the OpenCTI dashboard is a specified-but-undeployed design — neither is claimed as more than that.
