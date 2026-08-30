# Hazvinei Nomatter Masiya

## Cybersecurity Analyst · Security Operations · Detection & Automation

**Enterprise IT Professional | CompTIA Security+ Certified | Google Cybersecurity**

12+ years of professional IT experience supporting Windows environments, infrastructure, access control, endpoint security, system hardening, troubleshooting, and business-critical operations — now focused on cybersecurity, security operations, detection, investigation, and automation.

Hands-on work across security operations, detection engineering, incident response, digital forensics, Windows and Active Directory security, network security, cloud security, and security automation.

---

## 🎯 What I Bring to a SOC / Security Team

**Target roles:** SOC Analyst (L1–L2) · Security Analyst · Security Operations · Detection Engineering · Threat Hunting  
**Proven:** Wazuh SIEM + custom detection rules · Live attack simulations with captured alerts · Incident response & DFIR workflows · 12+ years enterprise infrastructure experience  
**Evidence:** 23 security labs and projects, with evidence clearly differentiated as observed, synthetic, or methodology/architecture-based.

## 🏆 Portfolio Highlights

**23 Security Labs | Evidence-Backed Security Portfolio**

- **Real Infrastructure** — Azure Domain Controller + Wazuh SIEM + Sysmon endpoint monitoring over Tailscale mesh VPN
- **Live Detection Validation** — Real Windows/Sysmon telemetry correlated with Wazuh detections, including LSASS process-access investigation mapped to MITRE ATT&CK T1003.001
- **Credible Findings** — Real Windows Security events, PCAP traffic, Sysmon telemetry, detection alerts, and investigation evidence documented where applicable

### Key Technical Wins

- Debugged and fixed a Sysmon `STATUS_STACK_BUFFER_OVERRUN` crash caused by field-name validation issues in Events 7 and 9
- Built working detections for T1003 (Credential Access), T1053/T1547 (Persistence), and T1059 (Execution)
- Validated live Windows/Sysmon/Wazuh detection of PowerShell process access targeting LSASS with custom rule `100312`, Level 13, mapped to T1003.001
- Resolved Wazuh false positives, pre-existing rule conflicts, rule-group naming inconsistencies, and stale event subscriptions
- Clearly distinguish observed telemetry from synthetic fixtures and methodology/architecture-based work

📊 [📖 Read Sysmon Case Study](#sysmon-case-study) · [🔍 Browse Security Portfolio](#-security-portfolio) · [📋 View Portfolio Structure](#-portfolio-structure) · [🔗 Live Portfolio](https://masiya-hub.org)

---

## 🔐 Security Portfolio

This repository documents practical security investigations, detection engineering projects, incident-response exercises, security assessments, automation, and infrastructure security work.

### Security Operations & Detection

- **Wazuh SIEM Detection Lab** — custom detection rules, File Integrity Monitoring, security event analysis
- **Sysmon Detection Engineering** — process and network activity detection
- **Active Directory Security** — Windows security events, privilege monitoring, identity security
- **Threat Hunting** — IOC analysis, suspicious activity investigation, MITRE ATT&CK mapping

### Offensive Security

- **Attack Simulation & Detection Engineering Lab** — MITRE ATT&CK techniques across real, self-owned platforms, paired with custom Wazuh detection rules and documented validation evidence

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

## 🧪 Hands-On Cybersecurity Training

- **TryHackMe** — Hands-on cybersecurity labs and security training  
  [View TryHackMe Profile →](https://tryhackme.com/p/norman.masiya)

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
- `Offensive-Security/` — real attack simulation and detection engineering lab, validated against live infrastructure, plus a methodology pentest report
- `AppSec-DevSecOps/`, `Enterprise-Security/` — supporting domain reports
- `Scripts/` — repository automation and quality-check tooling
- `tests/` — pytest suite covering the automation scripts above
- `Coursework/` — Google Cybersecurity Professional Certificate labs and early independent follow-on projects, kept separate from the evidence-backed labs above

Projects contain technical documentation, investigation methodology, configurations, scripts, reports, and supporting evidence where applicable.

Work is identified where appropriate as observed, synthetic, or architecture/methodology-based.

---

<!-- START_SECTION:activity -->
### Recent Portfolio Activity

- **Portfolio protection and ownership notice** — copyright and usage notice added
- **Automated resume build** — current recruiter-facing resume maintained through repository automation
- **Live detection validation** — Windows/Sysmon/Wazuh LSASS detection evidence published
- **Recruiter accuracy pass** — portfolio content standardized for consistency and evidence clarity
- **Lab portfolio expansion** — security operations, DFIR, network, cloud, application, and automation work consolidated
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

My background combines 12+ years of professional enterprise IT experience with hands-on cybersecurity engineering and security operations work.

---

## 🌐 Portfolio Website

**https://masiya-hub.org**

The interactive portfolio provides a recruiter-friendly overview of my security projects, technical capabilities, certifications, and supporting evidence.

---

## 📫 Contact

**Location:** Harare, Zimbabwe  
Open to local and international cybersecurity opportunities.

**Email:** norman.masiya@gmail.com  
**LinkedIn:** https://www.linkedin.com/in/hazvinei-masiya/

---

## ⚠️ Disclaimer

This repository is maintained for professional portfolio and educational purposes.

Security testing is performed only against systems and environments that are intentionally authorized for testing. Where projects use simulated or synthetic scenarios, this is identified in the accompanying documentation.

---

## © Portfolio Ownership

Original portfolio materials are protected by the repository's copyright and usage notice. Public availability is intended for professional review and does not grant permission to reproduce, republish, redistribute, present the work as your own, or commercially reuse original portfolio materials without permission.
