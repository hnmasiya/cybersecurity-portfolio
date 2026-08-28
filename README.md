# Hazvinei Nomatter Masiya

## Cybersecurity Analyst · Security Operations · Detection & Automation

Enterprise IT Professional | CompTIA Security+ | Google Cybersecurity

12+ years of hands-on enterprise IT experience (since March 2014) supporting Windows environments, infrastructure, access control, endpoint security, system hardening, troubleshooting, and business-critical operations — now focused on cybersecurity, security operations, detection, investigation, and automation.

Hands-on work across security operations, detection engineering, incident response, digital forensics, Windows and Active Directory security, network security, cloud security, and security automation.

---

## 🎯 Portfolio Highlights

**23/23 Security Labs — 100% Evidence-Backed**

✅ **Real Infrastructure** — Deployed Azure Domain Controller + Wazuh SIEM + Sysmon endpoint monitoring over Tailscale mesh VPN

✅ **Live Attack Simulations** — 6 of 6 attack scenarios trigger real Wazuh alerts (3 MITRE techniques × 2 platforms: Linux + Windows)

✅ **Credible Findings** — 409 real Windows Security events analyzed, 52 PCAP packets extracted, real Sysmon telemetry correlated with detections

**Key Technical Wins**
- Debugged & fixed Sysmon `STATUS_STACK_BUFFER_OVERRUN` crash (root cause: field name validation in Events 7 & 9)
- Built working detections for T1003 (Credential Access), T1053/T1547 (Persistence), T1059 (Execution)
- Resolved 4 real issues in the loop: Wazuh false positives, pre-existing rule conflicts, rule group naming inconsistencies, stale event subscriptions
- All labs tested against synthetic fixtures *and* real infrastructure — no shortcuts

📊 23/23 Security Labs — Evidence-Backed | [📖 Read Sysmon Case Study](#sysmon-case-study) | [🔍 Browse Evidence](#evidence)

---

## 🔐 Security Portfolio

This repository documents practical security investigations, detection engineering projects, incident-response exercises, security assessments, automation, and infrastructure security work.

### Security Operations & Detection

- **Wazuh SIEM Detection Lab** — custom detection rules, File Integrity Monitoring, security event analysis
- **Sysmon Detection Engineering** — process and network activity detection
- **Active Directory Security** — Windows security events, privilege monitoring, identity security
- **Threat Hunting** — IOC analysis, suspicious activity investigation, MITRE ATT&CK mapping

### Offensive Security

- **Attack Simulation & Detection Engineering Lab** — 3 MITRE ATT&CK techniques (Execution, Persistence, Credential Access) designed to run against 2 real, self-owned platforms, each paired with a real custom Wazuh detection rule

### Incident Response & Digital Forensics

- **Enterprise Ransomware Incident Response** — investigation workflow, containment, evidence handling, recovery planning
- **Linux DFIR Investigation** — forensic evidence analysis, SHA-256 verification, timeline reconstruction
- **Windows Memory Forensics** — memory acquisition and analysis
- **Advanced Threat Operations** — threat hunting, malware-related investigation, Linux and container security

### Network Security

- **PCAP Network Security Analysis** — traffic investigation, scanning detection, IOC extraction
- **Wireshark / tshark**
- **Nmap**
- Network reconnaissance and security analysis

### Application Security

- **DVWA Security Assessments**
- OWASP-based web security testing
- Burp Suite
- Vulnerability identification and evidence-driven reporting

### Cloud & Infrastructure Security

- **GCP Secure Landing Zone** — org policy guardrails, folder structure, Shared VPC, centralized logging
- Terraform Infrastructure as Code
- Cloud security architecture
- IAM security and least privilege
- Cloud Security Posture Management

### Security Automation

- Python
- Bash
- PowerShell
- Security log parsing
- Detection tooling
- Evidence-processing automation
- Pytest unit test suite covering the automation scripts (`tests/`)

---

## 🧰 Core Technologies

| Area | Technologies |
|---|---|
| SIEM & Detection | Wazuh, Sysmon, Sigma |
| DFIR | Volatility, AVML, forensic analysis |
| Network Security | Wireshark, tshark, Nmap |
| Windows Security | Windows Server, Active Directory, PowerShell |
| Linux | Linux administration, DFIR, security tooling |
| Application Security | Burp Suite, OWASP, DVWA |
| Cloud | GCP, AWS security concepts |
| Infrastructure as Code | Terraform |
| Automation | Python, Bash, PowerShell |
| Frameworks | MITRE ATT&CK, OWASP |

---

## 🏆 Certifications

- **CompTIA Security+ — SY0-701**
- **Google Cybersecurity Professional Certificate**
- **Google IT Support Professional Certificate**

---

## 🎓 Education

- **National Diploma in Information Communication Technology**
  Harare Polytechnic

---

## 📂 Portfolio Structure

The repository is organized around practical security domains:

- `SIEM/` — Wazuh detection engineering, alert investigation, File Integrity Monitoring
- `Security-Automation/` — Python tooling for alert triage, enrichment, log anomaly detection, file integrity monitoring
- `Threat-Hunting/` — hypothesis-driven hunts and offline detection validation
- `Endpoint-Security/` — Windows/Sysmon detection engineering
- `Incident-Response/` — investigation workflow, containment, evidence handling
- `DFIR/` — Linux forensic investigation, IOC extraction
- `Network-Security/` — PCAP analysis, Wireshark, Nmap
- `Web-Security/` — DVWA and OWASP Juice Shop assessments, PortSwigger Academy
- `Active-Directory/` — Windows/AD security lab
- `Cloud-Security/` — cloud security fundamentals; Terraform/PowerShell IaC for an Azure Windows Server lab and a GCP Secure Landing Zone
- `Linux-Security/` — Linux host hardening audit lab, validated against a real personal host
- `Docker-Labs/` — container configuration security audit lab, validated against a real Docker host
- `Offensive-Security/` — real attack simulation and detection engineering lab (designed, awaiting execution), plus a methodology pentest report
- `AppSec-DevSecOps/`, `Enterprise-Security/` — supporting domain reports
- `Scripts/` — repository automation and quality-check tooling
- `tests/` — pytest suite covering the automation scripts above
- `Coursework/` — Google Cybersecurity Professional Certificate labs (2023) and early independent follow-on projects, kept separate from the evidence-backed labs above

Projects contain technical documentation, investigation methodology, configurations, scripts, reports, and supporting evidence where applicable.

Work is identified where appropriate as observed, synthetic, or architecture/methodology-based.

---

<!-- START_SECTION:activity -->
### Recent Lab & Security Updates
* Merge: Complete Attack Simulation & Detection Engineering Lab (6 of 6 combos with live-fired alerts) (9 hours ago)
* Add real T1003 Windows Credential Access evidence; 6 of 6 combos proven (9 hours ago)
* Add real T1053/T1547 Windows Persistence evidence; 5 of 6 combos proven (11 hours ago)
* Add real T1059 (Execution) Windows evidence; 4 of 6 combos proven (#60) (11 hours ago)
* Chain T1053 Windows rule under pre-existing community Sysmon rule (#59) (11 hours ago)
<!-- END_SECTION:activity -->

## 🎯 Career Focus

Currently targeting opportunities in:

- SOC Analyst
- Security Analyst
- Security Operations
- Detection Engineering
- Incident Response
- Digital Forensics
- Information Security
- Security Engineering

My background combines enterprise IT operations experience with hands-on cybersecurity engineering and security operations work.

---

## 🌐 Portfolio Website

**https://masiya-hub.org**

The interactive portfolio provides a recruiter-friendly overview of my security projects, technical capabilities, certifications, and supporting evidence.

---

## 📫 Contact

**Location:** Harare, Zimbabwe

Open to local and international cybersecurity opportunities.

**Email:** norman.masiya@gmail.com

---

## ⚠️ Disclaimer

This repository is maintained for professional portfolio and educational purposes.

Security testing is performed only against systems and environments that are intentionally authorized for testing. Where projects use simulated or synthetic scenarios, this is identified in the accompanying documentation.
