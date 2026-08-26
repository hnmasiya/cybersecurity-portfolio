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

**Evidence-backed offline detection engineering project**

* Synthetic Windows and Sysmon-style endpoint telemetry
* PowerShell execution detection
* Failed Windows authentication detection
* PowerShell network-connection detection
* Suspicious parent/child process detection
* Deterministic Python validation
* JSON and CSV evidence
* MITRE ATT&CK contextual mapping

**Current status:** Offline/synthetic validation. A live Windows/Sysmon endpoint is not currently claimed as repository evidence.

[View Windows / Sysmon Detection Lab](./Endpoint-Security/Windows-Sysmon-Detection-Lab/README.md)

### 📊 Wazuh Detection Engineering

**Evidence-backed offline validation project**

* Custom authentication detection rules
* Rule XML validation
* Synthetic authentication test events
* Deterministic Python rule-validation harness
* JSON and CSV validation evidence
* MITRE ATT&CK contextual mapping

**Important:** This project is explicitly documented as **offline Wazuh rule validation** because Wazuh Manager is not currently installed on the workstation.

[View Detection Engineering Lab](./SIEM/Wazuh/Detection-Engineering-Lab/README.md)

### ☁️ Azure Windows Server Security Lab

**Evidence-backed — deployed**

* Terraform provisioning a Windows Server 2022 VM in Azure: locked-down NSG (RDP restricted to a single admin IP, no default-open rule), no secrets committed, daily auto-shutdown for cost control
* PowerShell that promoted the VM to an Active Directory Domain Controller (`lab.local`) and applied an audit-policy/hardening baseline
* Real Windows Security event data exported and fed into the Active Directory Detection Lab below, closing its "live DC pending" gap end-to-end

**Current status:** Deployed to a real Azure subscription and verified — see the lab's `Evidence/` folder for `Get-ADDomain` output, the applied audit policy, the full Azure resource list, and 409 real exported events analyzed for 392 findings (1 CRITICAL, 16 HIGH, 375 MEDIUM).

[View Azure Windows Server Lab](./Cloud-Security/Azure-Windows-Server-Lab/README.md)

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

**Evidence-bounded methodology project**

The active Nmap project documents an authorized reconnaissance workflow and explicitly avoids claiming specific scan results because raw Nmap output is not currently stored in the project.

[View Nmap Report](./Network-Security/Nmap/Reports/Nmap-Network-Reconnaissance.md)

### 🕵️ Wireshark Packet Analysis

**Evidence-bounded methodology project**

The active Wireshark project documents the packet-analysis workflow and clearly separates methodology from verified packet evidence. The repository's separate PCAP Analysis project contains the currently preserved packet-capture evidence.

[View Wireshark Report](./Network-Security/Wireshark/Reports/Wireshark-Packet-Analysis.md)

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
