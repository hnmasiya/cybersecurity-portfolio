# Cybersecurity Portfolio — Hazvinei Nomatter Masiya

## SOC Analysis • Detection Engineering • Incident Response • Security Automation

**CompTIA Security+ Certified | 12+ Years Enterprise IT | Cybersecurity Portfolio**

Hands-on cybersecurity portfolio focused on **SOC operations, detection engineering, incident investigation, Windows/Active Directory security, network security, cloud security, DFIR, and security automation**.

My professional foundation is enterprise IT/infrastructure. The cybersecurity work here is clearly separated into **professional experience, independent authorized labs, coursework, and virtual job simulations**. Evidence is labeled **observed, synthetic, or methodology/architecture-based** so reviewers can quickly distinguish demonstrated telemetry from simulated or design work.

### Recruiter / Hiring Manager Quick View
- **SOC / SIEM:** Wazuh, Windows Security, Sysmon, alert triage, custom detections
- **Detection Engineering:** attack simulation, rule development, validation, MITRE ATT&CK mapping
- **DFIR / IR:** evidence preservation, forensic analysis, IOC extraction, investigation workflows
- **Windows / AD:** authentication events, privilege monitoring, least privilege, hardening
- **Network Security:** Nmap, Wireshark/tshark, PCAP analysis, reconnaissance
- **Cloud Security:** GCP, Terraform, IAM, VPC controls and landing-zone architecture
- **Automation:** Python, Bash, PowerShell and repeatable validation workflows

### Start Here
**[SOC Evidence Map](SOC-ANALYST-EVIDENCE-MAP.md)** · **[Security Tools Inventory](SECURITY-TOOLS-INVENTORY.md)** · **[Featured Labs](#featured-evidence)** · **[Certifications](#certifications--professional-credentials)** · **[Resume](Resume_Hazvinei_Masiya.md)** · **[Live Portfolio](https://masiya-hub.org/)**

### CI / Security Controls
[![Security Scan](https://github.com/hnmasiya/cybersecurity-portfolio/actions/workflows/security-scan.yml/badge.svg)](https://github.com/hnmasiya/cybersecurity-portfolio/actions/workflows/security-scan.yml)
[![Portfolio Quality](https://github.com/hnmasiya/cybersecurity-portfolio/actions/workflows/portfolio-quality.yml/badge.svg)](https://github.com/hnmasiya/cybersecurity-portfolio/actions/workflows/portfolio-quality.yml)
[![Trust Monitor](https://github.com/hnmasiya/cybersecurity-portfolio/actions/workflows/portfolio-trust-monitor.yml/badge.svg)](https://github.com/hnmasiya/cybersecurity-portfolio/actions/workflows/portfolio-trust-monitor.yml)

## Featured Evidence

### 🛡️ SOC & Detection
- **Wazuh SIEM** — alert triage, custom rules, File Integrity Monitoring and security-event analysis
- **Windows + Sysmon** — endpoint telemetry, process activity and detection validation
- **Detection Engineering** — attack simulation, rule development, validation and MITRE ATT&CK mapping

### 🚨 Incident Response & DFIR
- LSASS process-access investigation mapped to **MITRE ATT&CK T1003.001**
- Linux forensic investigation and evidence verification
- Windows memory-forensics exercises
- Incident-response workflows covering investigation, containment, evidence handling and recovery planning

### 🖥️ Windows & Active Directory Security
- Windows Security event analysis
- Active Directory identity and access-control scenarios
- Least privilege and privilege monitoring
- Endpoint hardening and security configuration

### 🌐 Network Security
- Wireshark / tshark PCAP analysis
- Nmap reconnaissance and network-security analysis
- Traffic investigation and IOC extraction

### ☁️ Cloud & Infrastructure Security
- GCP secure landing-zone architecture
- Terraform infrastructure-as-code
- VPC and IAM security concepts
- Infrastructure security controls and hardening

### ⚙️ Security Automation
- Python security tooling
- Bash and PowerShell workflows
- Security-log parsing
- Detection and evidence-processing automation
- Automated repository quality and validation checks

## Featured Evidence

| Priority | Project Area | What to Look For |
|---|---|---|
| **1** | **SOC / SIEM** | [Windows → Sysmon → Wazuh](SIEM/Wazuh/) telemetry, detections and alert investigation |
| **2** | **Detection Engineering** | [Attack simulation + custom Wazuh rules](Offensive-Security/Attack-Simulation-Detection-Lab/), validation and MITRE mapping |
| **3** | **Incident Response / DFIR** | [Investigation workflow](Incident-Response/), evidence handling and forensic analysis |
| **4** | **Windows / AD Security** | [Windows / AD security](Active-Directory/), authentication events and privilege monitoring |
| **5** | **Network Security** | [Nmap + Wireshark/PCAP](Network-Security/), reconnaissance and IOC analysis |
| **6** | **Cloud Security** | [GCP + Terraform](Cloud-Security/), IAM/VPC controls and landing-zone architecture |
| **7** | **Application Security** | DVWA and OWASP Juice Shop assessments |
| **8** | **Automation** | Python/Bash/PowerShell security workflows and validation tooling |

## Evidence Standard

For major projects, documentation aims to cover:

1. Objective and security scenario
2. Environment and tooling
3. Procedure or attack simulation
4. Evidence collected
5. Detection/analysis performed
6. Findings and security impact
7. MITRE ATT&CK or relevant framework mapping
8. Remediation and hardening
9. Validation and expected outcome
10. Lessons learned

Projects are explicitly distinguished as **professional experience, independent hands-on work, or coursework** where applicable. No simulated activity is presented as client or production work, and self-owned lab infrastructure is not described as production infrastructure.

## Core Technologies

**SIEM & Detection:** Wazuh · Sysmon · Sigma · MITRE ATT&CK  
**DFIR:** Volatility · AVML · forensic analysis  
**Windows / Identity:** Windows Server · Active Directory · PowerShell · Microsoft 365  
**Network Security:** Wireshark · tshark · Nmap · TCP/IP  
**Application Security:** Burp Suite · OWASP · DVWA · OWASP Juice Shop  
**Cloud / IaC:** GCP · Terraform · VPC · IAM  
**Automation:** Python · Bash · PowerShell

## Repository Structure

- `SIEM/` — Wazuh detection engineering and alert investigation
- `Endpoint-Security/` — Windows/Sysmon detection engineering
- `Active-Directory/` — Windows and AD security
- `Incident-Response/` — investigation and response workflows
- `DFIR/` — forensic investigation and IOC analysis
- `Threat-Hunting/` — hypothesis-driven security investigations
- `Network-Security/` — PCAP analysis and reconnaissance
- `Web-Security/` — DVWA and OWASP Juice Shop assessments
- `Cloud-Security/` — cloud security and infrastructure-as-code
- `Security-Automation/` / `Automation/` — security tooling and repeatable workflows
- `AppSec-DevSecOps/` — application and pipeline security work
- `Executive-Security-Reporting/` — security findings translated for decision-makers
- `Coursework/` — coursework and learning exercises kept separate from evidence-backed labs
- `tests/` — automated tests for portfolio automation tooling
- `.github/workflows/` — repository quality, security and maintenance automation

## Forage Cybersecurity Job Simulations

These are **virtual job simulations completed through Forage** and are listed separately from paid employment and independent technical labs.

### Mastercard Cybersecurity Job Simulation — Forage
**Completed:** September 20, 2026

- Designed a phishing email simulation using a realistic security-awareness scenario.
- Interpreted phishing simulation results and identified teams requiring additional awareness training from the supplied campaign data.
- Produced a phishing-awareness training presentation covering phishing tactics, red flags, reporting and prevention.
- Skills demonstrated: cybersecurity, security awareness, phishing analysis, security training, data analysis, data visualization, communication, problem solving and strategy.
- [View the dedicated Mastercard simulation repository](https://github.com/hnmasiya/mastercard-cybersecurity-job-simulation)

### Datacom Cyber Security Operations Job Simulation — Forage
**Completed:** September 20, 2026

- Investigated a simulated cyberattack and documented findings, indicators, response priorities and security recommendations.
- Conducted a comprehensive cybersecurity risk assessment using a 5×5 likelihood/consequence approach.
- Assessed phishing, ransomware, third-party exposure, e-commerce/AWS and remote-access risks in the simulated client environment.
- Skills demonstrated: information security, OSINT, research, risk assessment, risk management, security analysis, analytical skills and communication.
- [View the dedicated Datacom simulation repository](https://github.com/hnmasiya/Datacom-Cyber-Security-Operations-Job-Simulation)

> **Evidence note:** These programs were Forage virtual job simulations, not employment with Mastercard or Datacom. Completion certificates are retained as evidence of program completion.

## Certifications & Professional Credentials

### Cybersecurity & AI Security

- **CompTIA Security+ Certification (SY0-701)** — CompTIA | Issued July 2026 | Expires July 2029
- **Introduction to AI Security** — AI Security University | Issued September 2026 | Credential ID: 7b4063a9-8d67-48aa-a520-d0246c8180cb
- **GRC Fundamentals** — CyberExam | Issued July 2026 | Credential ID: CE-2026-509566
- **ICSI | CNS Certified Network Security Specialist** — DensinityOne | Issued April 2020 | Credential ID: 17094358
- **Junior Cybersecurity Analyst Career Path** — Cisco | Issued July 2023
- **Introduction to Cybersecurity** — Cisco | Issued July 2023

### Google, IBM & AI Credentials

- **Google Cybersecurity Specialization by Google** — Coursera | Issued July 2023 | Credential ID: V6XBG8932LUH
- **Google IT Support Specialization by Google** — Coursera | Issued June 2025 | Credential ID: NMYMY9JFLCX8
- **Introduction to Generative AI** — Google | Issued July 2025 | Credential ID: 16990276
- **Google AI Essentials by Google** — Coursera | Issued July 2025 | Credential ID: Z5KRK2EECS8Q
- **Artificial Intelligence Fundamentals by IBM** — IBM | Issued June 2025
- **Google Cybersecurity Professional Certificate** — Google
- **Google IT Support Professional Certificate** — Google

### Cybersecurity Job Simulation

- **Mastercard — Cybersecurity Job Simulation** — Forage | Issued September 2026 | Credential ID: c6HXyP6y7XvatYzre

> **Evidence note:** Credentials and virtual job simulations are listed based on the credential records shown in my professional profile. Virtual job simulations are not employment with the named companies.

## Education

- **Diploma in Information Technology** — Macmaine School of Computing
- **Diploma in PC Maintenance and Networking** — Macmaine School of Computing
- **BSc in Computer Science** — Unicaf University (In Progress)

## Professional Foundation

My cybersecurity work builds on 12+ years of enterprise IT operations across Windows environments, Active Directory, access control, endpoint protection, system hardening, patch management, infrastructure troubleshooting and business-critical support.

That foundation informs my approach to security: understand the environment, identify risk, protect systems, detect abnormal activity, investigate evidence, and remediate the underlying issue.

## Career Focus

**Primary:** SOC Analyst · Security Operations Analyst · Cybersecurity Analyst  
**Secondary:** Detection Engineering · Incident Response · Threat Hunting · Security Automation · Junior Security Engineering

<!-- START_SECTION:activity -->
### Recent Lab & Security Updates
* auto: update dynamic lab activity feed (#1245) (24 hours ago)
* auto: sync public GitHub project index (#1244) (29 hours ago)
* auto: sync public GitHub project index (#1243) (29 hours ago)
* fix: stop portfolio sync self-trigger loop (#1242) (29 hours ago)
* auto: sync public GitHub project index (#1241) (29 hours ago)
<!-- END_SECTION:activity -->

## 🌐 Portfolio

**Live portfolio:** https://masiya-hub.org/  
**GitHub profile:** https://github.com/hnmasiya  
**LinkedIn:** https://www.linkedin.com/in/hazvinei-masiya/

## ⚠️ Responsible Security Use

All security testing is performed only against systems and environments intentionally authorized for testing. Simulated and synthetic scenarios are identified in their accompanying documentation.

## © Portfolio Ownership

Original portfolio materials are protected by the repository's copyright and usage notice. Public availability is intended for professional review and does not grant permission to reproduce, republish, redistribute, present the work as your own, or commercially reuse original portfolio materials without permission.

<!-- AUTO_PORTFOLIO_PROJECT_INDEX_START -->
## Automatically Synced Public GitHub Projects

_Generated from public, non-fork, non-archived repositories owned by `hnmasiya`. Descriptions are taken from repository metadata or README content; no project claims or metrics are invented._

- **[mastercard-cybersecurity-job-simulation](https://github.com/hnmasiya/mastercard-cybersecurity-job-simulation)** — Mastercard Cybersecurity Job Simulation — Forage Completed: September 20, 2026 This repository documents my completion of the Mastercard Cybersecurity Job Simulation on Forage. The simulation placed me in a Security Awareness Team scenar...
- **[Datacom-Cyber-Security-Operations-Job-Simulation](https://github.com/hnmasiya/Datacom-Cyber-Security-Operations-Job-Simulation)** — Datacom Cyber Security Operations Job Simulation — Forage Completed: September 20, 2026 This repository documents my completed Datacom Cyber Security Operations Job Simulation on the Forage platform. The simulation provided practical, sc...
- **[ad-security-log-parser](https://github.com/hnmasiya/ad-security-log-parser)** — Python security tooling for Windows Security Event Log analysis and privileged group-change detection
- **[gcp-terraform-secure-vpc](https://github.com/hnmasiya/gcp-terraform-secure-vpc)** — Terraform-based cloud security architecture with strict IAM policies and firewall rules
- **[wazuh-siem-detection-lab](https://github.com/hnmasiya/wazuh-siem-detection-lab)** — Custom Wazuh SIEM detection rules mapped to MITRE ATT&CK framework and log analysis

<!-- AUTO_PORTFOLIO_PROJECT_INDEX_END -->

