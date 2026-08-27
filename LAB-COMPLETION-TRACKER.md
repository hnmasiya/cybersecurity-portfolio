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
| Attack Simulation & Detection Engineering Lab | In progress — 5 of 6 live-fired | 3 MITRE ATT&CK techniques (T1059 Execution, T1053/T1547 Persistence, T1003 Credential Access) × 2 real, self-owned platforms (home-lab Linux host, Azure DC) — all 3 techniques on Linux have real, captured Wazuh alerts (`Evidence/t1059-linux-alert.json`, `Evidence/t1053-linux-alert.json`, `Evidence/t1003-linux-alert.json`); each involved finding and fixing a real issue live (a Wazuh false positive against its own internal health checks, a Wazuh FIM behavior where the scan right after an agent restart never alerts, and a real false positive from sudo's own internal `/etc/shadow` read during authentication). On Windows, Execution has a real live-fired alert too (`Evidence/t1059-windows-alert.json`) after fixing a missing Sysmon event-channel collector on the DC's Wazuh agent. Persistence on Windows now also has a real live-fired alert (`Evidence/t1053-windows-alert.json`) after chasing down four real issues in turn: a wrong Sysmon rule-group name (an inconsistency in Wazuh's own upstream ruleset), a pre-existing community Sysmon detection rule already installed on the manager that was silently winning the match ahead of the custom rule (fixed by chaining the custom rule underneath it via `if_sid`), and then a deployment gap where that fix never actually reached the manager's disk on the first `docker cp` (caught by `cat`-ing the on-disk file and finding the pre-fix version still there, then redeploying and verifying before restart). Credential Access/Windows (`procdump` against `lsass.exe`) is the one combination not yet run |
| Enterprise AD Audit | Methodology | Illustrative write-up, not a live finding — no separate authorized AD domain accessible from this environment beyond the Azure DC already exercised above |

## Live Windows Endpoint
[`Cloud-Security/Azure-Windows-Server-Lab`](./Cloud-Security/Azure-Windows-Server-Lab/README.md) provides a real, deployed Azure Domain Controller, fully validated end-to-end: its real Security event log is exported and analyzed against `ad_security_event_analyzer.py`, Sysmon (SwiftOnSecurity config) captures real telemetry analyzed against the Windows/Sysmon Endpoint Detection Lab's logic, and its Wazuh Agent is connected to the project's Wazuh Manager over a Tailscale mesh VPN, generating real Wazuh-side alerts (MITRE-mapped detections, CIS Benchmark SCA findings). See its `Evidence/` folder for all three.

## Remaining Gaps
Enterprise AD Audit remains an intentionally-illustrative Methodology write-up — it would need a separate authorized Active Directory domain, which isn't a stand-in for what's already evidence-backed elsewhere in this repo (the AD Detection Lab's real event analysis, the Azure Windows Server Lab's real domain controller). Offensive Security now has a real counterpart in the Attack Simulation & Detection Engineering Lab — all 3 Linux techniques have real, captured Wazuh alerts; the 3 Windows combinations are designed and ready but not yet run. Every other lab, including AppSec/SAST as of this pass, is validated against real, live evidence rather than synthetic fixtures alone. The GCP Secure Landing Zone is real Terraform, still fully pending a real GCP organization.
