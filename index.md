---
layout: default
title: "Enterprise Cybersecurity & SOC Operations Portfolio"
---

<p align="center">
  <b>🌐 QUICK NAVIGATION</b><br>
  <a href="#-about-me">About Me</a> |
  <a href="#-technical-competency--tool-stack">Tool Stack</a> |
  <a href="#-featured-security-labs">Security Labs</a> |
  <a href="./LAB-COMPLETION-TRACKER.md">Lab Tracker</a>
</p>

---

## 👤 About Me

I am a **CompTIA Security+ certified IT professional with 12+ years of enterprise IT experience** (since March 2014), building on that foundation with a strong hands-on cybersecurity focus across Security Operations, SIEM, incident investigation, network security, digital forensics, threat hunting, and security automation.

My professional background includes supporting **enterprise sites and business-critical IT infrastructure**, with experience across Windows Server, Active Directory, endpoint security, networking, access control, system hardening, patch management, troubleshooting, and infrastructure operations.

Alongside my professional IT experience, I have built and documented a practical cybersecurity portfolio demonstrating hands-on capability across:

- **SOC & SIEM:** Wazuh, security monitoring, log analysis, alert investigation, custom detection engineering, and File Integrity Monitoring (FIM)
- **DFIR:** Linux forensic investigation, evidence preservation, SHA-256 verification, timeline reconstruction, IOC extraction, and privileged activity analysis
- **Network Security:** Wireshark, PCAP analysis, Nmap, network reconnaissance, and enterprise SD-WAN
- **Web Security:** Burp Suite, OWASP Top 10, SQL injection, XSS, CSRF, JWT analysis, DVWA, and OWASP Juice Shop
- **Security Automation:** Python, Bash, and PowerShell for IOC extraction, log anomaly detection, alert enrichment, file integrity monitoring, and detection validation
- **Threat Hunting & Detection:** MITRE ATT&CK mapping, investigation workflows, detection validation, and security-focused automation

My approach combines **enterprise IT operations experience with practical cybersecurity investigation, detection, and infrastructure security skills**. I focus on understanding security events, validating evidence, documenting findings, and developing repeatable security workflows.

I am targeting opportunities as a **SOC Analyst, Cybersecurity Analyst, Security Operations Analyst, or Information Security Administrator**, where I can apply my enterprise infrastructure experience while contributing to security monitoring, investigation, detection, and incident response.

### Portfolio Evidence

This portfolio contains documented evidence of hands-on work, including **security reports, forensic artifacts, screenshots, detection rules, investigation workflows, scripts, automation tooling, PCAP analysis, and validation utilities**.

## 🛠️ Technical Competency & Tool Stack

### 🔵 Defensive Operations & Monitoring

* **SIEM / Detection:** Wazuh concepts, custom detection rules, authentication-event analysis
* **Network Security:** PCAP analysis, TShark, Wireshark methodology, Nmap methodology
* **SOC Operations:** Alert triage, incident investigation, IOC extraction, evidence preservation
* **Automation:** Python, Bash, deterministic validation and evidence-generation workflows
* **Endpoint / Infrastructure:** Windows administration, Active Directory, Linux security, system hardening

### 🔴 Web & Application Security

* **Web Security:** SQL injection, XSS, CSRF, brute force, command injection, file inclusion, file upload, session security
* **Tools:** Burp Suite Community Edition, OWASP Juice Shop, DVWA
* **Frameworks:** OWASP, MITRE ATT&CK

---

## 🔬 Featured Security Labs

### 📡 PCAP Network Security Monitoring & Incident Investigation

**Evidence-backed project**

* Actual laboratory PCAP preserved in the repository
* TShark protocol and HTTP extraction
* Python-based suspicious-request detection
* IOC extraction and evidence generation
* SOC triage, investigation and reporting workflow
* Synthetic laboratory traffic explicitly separated from real-world attacker activity

[View PCAP Analysis](./Network-Security/PCAP-Analysis/README.md)

### 🎯 Threat Hunting & Detection Validation

**Evidence-backed offline threat-hunting project**

* Hypothesis-driven suspicious-login hunting
* Repeated failed-authentication analysis
* Encoded PowerShell hunting
* PowerShell network-activity hunting
* Synthetic Windows and endpoint telemetry
* Deterministic Python hunt validation
* JSON and CSV evidence
* MITRE ATT&CK contextual mapping

**Current status:** Offline/synthetic validation. Live enterprise telemetry is not claimed as repository evidence.

[View Threat Hunting Detection Validation](./Threat-Hunting/Detection-Validation-Lab/README.md)

### 🖥️ Windows / Sysmon Endpoint Detection Engineering

**Evidence-backed detection engineering project — validated against real endpoint telemetry**

* Synthetic and real Windows/Sysmon endpoint telemetry
* PowerShell execution detection
* Failed Windows authentication detection
* PowerShell network-connection detection
* Suspicious parent/child process detection
* Deterministic Python validation
* JSON and CSV evidence
* MITRE ATT&CK contextual mapping

**Current status:** Complete — validated against both synthetic fixtures and real Sysmon/Security telemetry (16 events, 5 findings) captured from a live, deployed Azure Domain Controller. See the [Azure Windows Server Lab](./Cloud-Security/Azure-Windows-Server-Lab/README.md) for the raw export and analysis.

[View Windows / Sysmon Detection Lab](./Endpoint-Security/Windows-Sysmon-Detection-Lab/README.md)

### 📊 Wazuh Detection Engineering

**Evidence-backed offline validation project**

* Custom authentication detection rules
* Rule XML validation
* Synthetic authentication test events
* Deterministic Python rule-validation harness
* JSON and CSV validation evidence
* MITRE ATT&CK contextual mapping

**Note:** These custom rules are validated offline via a deterministic Python harness rather than by loading them into the live Wazuh Manager and triggering real events. For a live, connected endpoint generating real Wazuh-side alerts, see the Azure Windows Server Lab below.

[View Detection Engineering Lab](./SIEM/Wazuh/Detection-Engineering-Lab/README.md)

### ☁️ Azure Windows Server Security Lab

**Evidence-backed — deployed**

* Terraform provisioning a Windows Server 2022 VM in Azure: locked-down NSG (RDP restricted to a single admin IP, no default-open rule), no secrets committed, daily auto-shutdown for cost control
* PowerShell that promoted the VM to an Active Directory Domain Controller (`lab.local`) and applied an audit-policy/hardening baseline
* Real Windows Security event data exported and fed into the Active Directory Detection Lab below, closing its "live DC pending" gap end-to-end
* Wazuh Agent connected to the project's Wazuh Manager over a private Tailscale mesh VPN, generating real MITRE-mapped alerts and CIS Benchmark compliance findings from Wazuh's own rule engine

**Current status:** Deployed to a real Azure subscription and verified — see the lab's `Evidence/` folder for `Get-ADDomain` output, the applied audit policy, the full Azure resource list, 409 real exported events analyzed for 392 findings (1 CRITICAL, 16 HIGH, 375 MEDIUM), and the live Wazuh Agent connection evidence.

[View Azure Windows Server Lab](./Cloud-Security/Azure-Windows-Server-Lab/README.md)

### 🐧 Linux Host Hardening Audit

**Evidence-backed — validated against a real, live host**

* CIS-benchmark-style checks: SSH config, sudoers (`NOPASSWD` scope), SUID binaries, world-writable files, legacy services, host firewall state
* Deterministic Python audit engine, validated first against synthetic fixtures containing both misconfigurations and compliant settings
* A real collector script (`sshd -T`, sudoers parsing, `find`-based SUID/permission scans, `systemctl`, `ufw`) run against a real personal Linux machine

**Current status:** 0 findings against the real host — earned, not assumed: no SSH server (zero attack surface), no `NOPASSWD` sudoers, active default-deny firewall, no legacy services, and all 26 real SUID binaries individually verified against their owning package. The verification process itself caught two real methodology issues along the way (an unprivileged scan that looked falsely clean, and hundreds of false positives from Docker/containerd image-layer storage) rather than accepting a clean number at face value.

[View Linux Host Hardening Lab](./Linux-Security/Hardening-Lab/README.md)

### 🐳 Container Configuration Security Audit

**Evidence-backed — validated against a real, live Docker host**

* CIS Docker Benchmark / MITRE ATT&CK for Containers-style checks: root user, unpinned image tags, hardcoded secrets, privileged mode, Docker socket mounts, host network mode
* Deterministic Python audit engine, validated first against synthetic fixtures containing both a fully-hardened config and common misconfigurations
* A real collector script (`docker inspect`-based, redacting all env var values before they ever touch disk) run against 8 real running containers on a home-lab Docker host

**Current status:** 14 real findings across 8 containers (1 CRITICAL, 10 HIGH, 3 MEDIUM), interpreted honestly rather than filtered: 5 containers running as root, 5 hardcoded secrets (the Wazuh Docker Compose quickstart's own plaintext demo credentials), a CRITICAL Docker-socket mount on Portainer (by design — it needs that access to manage the host's containers), and 3 unpinned image tags. One container in the same stack (`wazuh-indexer`) produced zero findings, showing the audit isn't just flagging everything indiscriminately.

[View Container Audit Lab](./Docker-Labs/Container-Audit-Lab/README.md)

### 🌐 DVWA Web Application Security

**Evidence-backed vulnerability assessment project**

* SQL Injection
* Blind SQL Injection
* XSS
* XSS DOM / Reflected / Stored
* CSRF
* Brute Force
* Command Injection
* File Inclusion
* File Upload
* Weak Session IDs
* Insecure CAPTCHA

The repository contains supporting screenshots and structured security reports.

[View DVWA](./Web-Security/DVWA/README.md)

### 🧪 OWASP Juice Shop

**Evidence-backed web-security project**

* Authentication testing
* JWT analysis
* SQL injection testing
* Sensitive-data exposure analysis
* Burp Suite traffic inspection
* OWASP-oriented assessment documentation

[View Juice Shop](./Web-Security/Juice-Shop/)

### 🔎 Nmap Reconnaissance

**Evidence-backed — real scan against a self-owned host**

* Full TCP port range (`-sV -sC -p-`) scan against the analyst's own home-lab machine, discovering 13 real open ports with service/version fingerprints
* Raw output preserved in all three Nmap formats (`.nmap`, `.xml`, `.gnmap`)
* An unrecognized service fingerprint (port 9443) independently verified with `curl`/`ss` rather than assumed, confirming Portainer is exposed on all network interfaces rather than scoped like the project's other services

**Current status:** Complete — see the raw scan output and the full write-up (including remediation recommendations: scope Portainer's binding, identify an unaccounted-for port, disable unused default services) for the honest read of what a real scan against this host actually revealed.

[View Nmap Report](./Network-Security/Nmap/Reports/Nmap-Network-Reconnaissance.md)

### 🕵️ Wireshark Packet Analysis

**Evidence-backed — real capture from live traffic**

* Real `tcpdump` capture (52 packets) on the analyst's own home-lab host, targeting the project's own Juice Shop container
* A genuine test of Juice Shop's known SQL-injection-vulnerable search endpoint, captured and analyzed alongside benign traffic
* This portfolio's existing `pcap_soc_analyzer.py` — previously validated only against a synthetic PCAP — run against the real capture

**Current status:** Complete — the analyzer correctly flagged the real SQLi-pattern request (HIGH, score 3) while correctly declining to flag a weaker scanner-User-Agent signal alone, confirming the detection logic holds up against real traffic, not just synthetic fixtures.

[View Wireshark Report](./Network-Security/Wireshark/Reports/Wireshark-Packet-Analysis.md)

### 🔍 Static Application Security Testing (SAST)

**Evidence-backed — real scan of this portfolio's own code**

* Real `bandit` static analysis scan of this repository's own 1,278-line Python codebase — not a fictional target
* One genuine High-severity finding (unnecessary `shell=True` command execution) identified and fixed
* Remaining findings triaged honestly: one confirmed scanner false positive, one documented-but-accepted defense-in-depth recommendation, and several low-risk findings reviewed and accepted rather than blindly cleared

**Current status:** Complete — re-scanned after remediation: 0 High, 3 Medium (documented), 10 Low (documented).

[View AppSec/SAST Report](./AppSec-DevSecOps/SAST-Reports/AppSec-Audit-Report.md)

### ☁️ GCP Secure Landing Zone

**Architecture / methodology — real Terraform, not yet deployed**

* Org-level policy guardrails: deny external IPs org-wide, disable service-account key creation, domain-restricted IAM, enforced uniform bucket access
* Environment folder structure (bootstrap, common, production, non-prod, development)
* Shared VPC host project: deny-all-ingress firewall baseline, per-region Cloud NAT for private-instance egress
* Organization-wide aggregated logging sink, so every project's audit logs land in one place regardless of which folder it's created under later

**Current status:** Formatting-checked (`terraform fmt -check`, clean). `terraform validate`/`plan`/`apply` not run — this build environment can't reach the Terraform provider registry, and no real org backs this yet. Same starting point the [Azure Windows Server Lab](./Cloud-Security/Azure-Windows-Server-Lab/README.md) had before it was actually deployed.

[View GCP Landing Zone Lab](./Cloud-Security/GCP-Landing-Zone-Lab/README.md)

### 🧩 OpenCTI Custom SOC Dashboard

**Methodology / design exercise**

* A single OpenCTI Workspace dashboard designed for shift-start SOC triage
* 13 widgets, each specified against OpenCTI's actual STIX 2.1 data model and real widget types (Number, Distribution, List, Timeline, Donut) — not a generic mockup
* Covers active alerts, open incidents, IOC volume, unpatched vulnerabilities tied to internal assets, MTTR trend, playbook execution rate, and TTP/threat-actor linkage

**Current status:** Design only — no live OpenCTI instance backs this. This build environment has no Docker daemon to run OpenCTI's real stack (OpenSearch, RabbitMQ, Redis, MinIO).

[View OpenCTI Dashboard Design](./Threat-Intelligence/OpenCTI-Dashboard-Design/OpenCTI-Custom-Dashboard-Design.md)

---

## 📈 Portfolio Architecture & Tracking

* 📋 **[Lab Completion Tracker](./LAB-COMPLETION-TRACKER.md)** — Portfolio progress and project status.
* 🛠️ **[Security Tools Inventory](./SECURITY-TOOLS-INVENTORY.md)** — Security tooling and lab inventory.

---

## 📜 Professional Credentials

* **CompTIA Security+**
* **Google Cybersecurity Certificate**
* **Google IT Support Certificate**

---

## 🎓 Certificate Coursework

The labs above are the current, evidence-backed portfolio. For the earlier **Google Cybersecurity Professional Certificate** coursework (awarded July 2023) that this work grew out of — security audits, Linux permissions, SQL log analysis, Python automation, network analysis, plus early independent follow-on projects — see [`Coursework/Google-Cybersecurity-Certificate-2023/`](./Coursework/Google-Cybersecurity-Certificate-2023/README.md).

---

## 📚 Evidence Philosophy

This portfolio separates:

**Observed evidence** → claims supported by stored lab artifacts.

**Methodology** → documented procedures where the underlying execution evidence is not currently preserved.

**Synthetic laboratory activity** → intentionally generated test activity that is clearly labelled as simulated.

No unsupported technical finding is intentionally presented as observed evidence.

---

## 🌐 GitHub Pages

The portfolio is published through GitHub Pages:

https://masiya-hub.org

The GitHub repository remains the authoritative source for the underlying reports, scripts and evidence.

---

### 🧭 SOC Analyst Evidence Map

A recruiter-focused mapping of SOC capabilities to the specific labs, scripts and evidence that demonstrate them.

[View the SOC Analyst Evidence Map](./SOC-ANALYST-EVIDENCE-MAP.md)
