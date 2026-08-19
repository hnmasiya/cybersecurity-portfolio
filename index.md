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

**IT Support Specialist pivoting into Tier 1 SOC Analyst operations.**

I combine enterprise IT support experience with hands-on cybersecurity work covering SIEM monitoring, detection engineering, incident investigation, network analysis, automation, vulnerability assessment, and evidence-driven security reporting.

* 📍 **Location:** Zimbabwe
* 💼 **Current Role:** IT Support Specialist
* 🎯 **Target Position:** Junior SOC Analyst / Tier 1 Incident Responder

---

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
* 🧾 **[Evidence Tracker](./EVIDENCE-TRACKER.md)** — Evidence mapping and supporting artifacts.

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

https://hnmasiya.github.io/cybersecurity-portfolio/

The GitHub repository remains the authoritative source for the underlying reports, scripts and evidence.

---
