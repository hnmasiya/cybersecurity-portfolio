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
| GCP Secure Landing Zone (IaC) | Architecture | Real Terraform (org policy guardrails, folder structure, Shared VPC, org-wide logging sink), formatting-checked; needs a real GCP *organization* (Cloud Identity/Workspace), which a standalone project doesn't have — `validate`/`plan`/`apply` pending that plus registry access this environment lacks |
| Attack Simulation & Detection Engineering Lab | In progress — 2 of 6 evidence-backed | 3 MITRE ATT&CK techniques (T1059 Execution, T1053/T1547 Persistence, T1003 Credential Access) × 2 real, self-owned platforms (home-lab Linux host, Azure DC) — T1059 Execution and T1053 Persistence on Linux both have real, captured Wazuh alerts (`Evidence/t1059-linux-alert.json`, `Evidence/t1053-linux-alert.json`); T1059's included finding and fixing a real false positive against Wazuh's own internal health checks, T1053's included discovering and working around a real Wazuh FIM behavior where the scan immediately after any agent restart never alerts; the other 4 combinations have real simulation scripts and detection rules written, ready to run |
| Enterprise AD Audit | Methodology | Illustrative write-up, not a live finding — no separate authorized AD domain accessible from this environment beyond the Azure DC already exercised above |

## Live Windows Endpoint
[`Cloud-Security/Azure-Windows-Server-Lab`](./Cloud-Security/Azure-Windows-Server-Lab/README.md) provides a real, deployed Azure Domain Controller, fully validated end-to-end: its real Security event log is exported and analyzed against `ad_security_event_analyzer.py`, Sysmon (SwiftOnSecurity config) captures real telemetry analyzed against the Windows/Sysmon Endpoint Detection Lab's logic, and its Wazuh Agent is connected to the project's Wazuh Manager over a Tailscale mesh VPN, generating real Wazuh-side alerts (MITRE-mapped detections, CIS Benchmark SCA findings). See its `Evidence/` folder for all three.

## Remaining Gaps
Enterprise AD Audit remains an intentionally-illustrative Methodology write-up — it would need a separate authorized Active Directory domain, which isn't a stand-in for what's already evidence-backed elsewhere in this repo (the AD Detection Lab's real event analysis, the Azure Windows Server Lab's real domain controller). Offensive Security now has a real, ready-to-run counterpart in the Attack Simulation & Detection Engineering Lab — the techniques, targets, and detection rules are real, only the actual execution and captured alerts are still pending. Every other lab, including AppSec/SAST as of this pass, is validated against real, live evidence rather than synthetic fixtures alone. The GCP Secure Landing Zone is real Terraform, still fully pending a real GCP organization.
