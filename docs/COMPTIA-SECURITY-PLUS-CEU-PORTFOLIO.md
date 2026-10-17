# CompTIA Security+ CEU Supporting Documentation
## Cybersecurity Portfolio — Hazvinei Nomatter Masiya

**Purpose:** Record independent cybersecurity learning and technical portfolio work that may be relevant to CompTIA Security+ Continuing Education (CE) review. This is supporting documentation, not a guarantee that any activity will be accepted for CEUs.

- **Candidate:** Hazvinei Nomatter Masiya
- **Certification:** CompTIA Security+ (SY0-701)
- **Portfolio repository:** https://github.com/hnmasiya/cybersecurity-portfolio
- **Professional portfolio:** https://masiya-hub.org/
- **LinkedIn:** https://www.linkedin.com/in/hazvinei-masiya/
- **Activity period:** Enter the actual start/end dates for each activity before submission.
- **Last reviewed:** 2026-10-14

> **Important:** Do not claim a CEU total from this repository alone. CompTIA determines whether an activity type, timing, content, documentation, and claimed hours meet current program requirements. Record only time actually spent. A GitHub commit, project, or README does not automatically qualify for CEUs.

## 1. Activity overview

This portfolio documents independent practical cybersecurity work in controlled lab environments, test data, and security tools. Areas include security monitoring, detection engineering, incident investigation, digital forensics, identity and access management, network security, cloud security, application security, and automation.

Core workflow: **Environment → Risk → Telemetry → Detection → Investigation → Remediation → Validation**

## 2. Technical activity and evidence index

| Activity | Skills and Security+ relevance | Evidence |
|---|---|---|
| Wazuh SIEM and detection engineering | Security monitoring, event analysis, custom detection rules, file-integrity monitoring, MITRE ATT&CK mapping | [Wazuh SIEM](https://github.com/hnmasiya/cybersecurity-portfolio/tree/main/SIEM/Wazuh/) |
| Splunk SOC Lab Track | Authentication-event hunting, endpoint/process telemetry, web-log investigation, SPL detections, dashboards, incident case investigation | [Splunk labs](https://github.com/hnmasiya/cybersecurity-portfolio/tree/main/SIEM/Splunk/) |
| Windows/Sysmon detection | Endpoint telemetry, process and security-event investigation, detection validation | [Windows/Sysmon lab](https://github.com/hnmasiya/cybersecurity-portfolio/tree/main/Endpoint-Security/Windows-Sysmon-Detection-Lab/) |
| Active Directory security and log parsing | Authentication events, failed logons, privileged-group changes, identity controls | [Active Directory](https://github.com/hnmasiya/cybersecurity-portfolio/tree/main/Active-Directory/) · [AD log parser](https://github.com/hnmasiya/ad-security-log-parser) |
| Digital forensics and incident response | Evidence handling, hashes/integrity, indicators of compromise, investigation and response workflows | [DFIR](https://github.com/hnmasiya/cybersecurity-portfolio/tree/main/DFIR/) · [Incident Response](https://github.com/hnmasiya/cybersecurity-portfolio/tree/main/Incident-Response/) |
| Network security | Authorized lab reconnaissance, packet-capture review, protocol and traffic analysis | [Network Security](https://github.com/hnmasiya/cybersecurity-portfolio/tree/main/Network-Security/) |
| Cloud security / infrastructure as code | Network segmentation, firewall policy, IAM/least privilege, Terraform-based controls | [Cloud Security](https://github.com/hnmasiya/cybersecurity-portfolio/tree/main/Cloud-Security/) · [GCP Terraform secure VPC](https://github.com/hnmasiya/gcp-terraform-secure-vpc) |
| Application security | Authorized web application testing, weakness identification, assessment and remediation concepts | [Web Security](https://github.com/hnmasiya/cybersecurity-portfolio/tree/main/Web-Security/) · [AppSec/DevSecOps](https://github.com/hnmasiya/cybersecurity-portfolio/tree/main/AppSec-DevSecOps/) |
| Security automation | Repeatable analysis workflows using Python, Bash, and PowerShell | [Security Automation](https://github.com/hnmasiya/cybersecurity-portfolio/tree/main/Security-Automation/) |

Before referencing a specific lab, verify its current state in the [Master Lab Completion & Evidence Register](https://github.com/hnmasiya/cybersecurity-portfolio/blob/main/LAB-COMPLETION-MASTER.md) and [Cybersecurity Lab Catalog](https://github.com/hnmasiya/cybersecurity-portfolio/blob/main/CYBERSECURITY-LAB-CATALOG.md). Do not present planned, incomplete, synthetic-only, or offline-only work as a live production deployment.

## 3. Learning outcomes to document

For each completed activity, retain only the outcomes supported by evidence:

- Interpret logs and telemetry to identify suspicious or policy-relevant activity.
- Explain how SIEM platforms collect, correlate, and present security events.
- Develop or review detection logic and test it against documented cases.
- Investigate authentication, endpoint, network, or application events systematically.
- Apply evidence-preservation practices, including cryptographic hashes where relevant.
- Explain identity/access controls, least privilege, and privileged-account monitoring.
- Evaluate segmentation, firewall rules, and cloud IAM configurations.
- Identify weaknesses in an authorized lab and document mitigation recommendations.
- Use scripts to make security analysis more repeatable and auditable.
- Record limitations, false positives, failed tests, and validation results.

## 4. Security+ topic crosswalk

This is a high-level study aid, **not an official CompTIA objective mapping or approval**. Use the current official exam objectives for the exact codes and wording.

| Security topic | Portfolio examples |
|---|---|
| Security operations and monitoring | Wazuh/Splunk monitoring, event analysis, alert triage |
| Threats, vulnerabilities, mitigations | Controlled simulations, web-security labs, detection/remediation notes |
| Security architecture | Network segmentation, cloud VPC, firewall policy, secure configuration |
| Identity and access management | Active Directory, authentication logs, privileged-group monitoring |
| Incident response | Investigation, triage, containment and recovery planning |
| Digital forensics | Evidence handling, hash verification, IOC analysis, forensic exercises |
| Security automation | Python, Bash, PowerShell workflows |
| Governance and risk concepts | Risk, impact, remediation, responsible-testing boundaries |

## 5. Activity record — duplicate for every discrete activity

### Activity [ID]: [Title]

- **Date completed:** [YYYY-MM-DD]
- **Start date (if multi-session):** [YYYY-MM-DD]
- **Actual time spent:** [Hours and minutes; explain calculation]
- **Activity category under current CompTIA rules:** [Verify before selecting]
- **Project/lab:** [Name]
- **Evidence URL:** [Direct link to files, commit, or release]
- **Environment:** [Lab VM, local test system, cloud sandbox, etc.]
- **Data type:** [Authorized telemetry / synthetic data / offline analysis / other]
- **Relevant official Security+ objective(s):** [Exact code and wording]

**Objective and scope:**  
[What security question or problem did the activity address?]

**Procedure performed:**  
[Steps personally performed; link scripts and lab instructions.]

**Evidence produced:**  
[Sanitized screenshots, logs, queries, scripts, detection tests, findings, hashes, or report.]

**Result and validation:**  
[What was observed and how it was checked. Separate observed results from expected outcomes.]

**Learning gained:**  
[What was learned and what could be improved.]

**Limitations:**  
[Failed tests, missing telemetry, synthetic data, assumptions, incomplete steps, etc.]

**Security+ relevance:**  
[Explain the relationship to the official objective.]

**Supporting documents retained:**  
[List evidence files and category-specific documentation.]

## 6. Evidence requirements and integrity

For each activity, preserve where applicable:

1. A dated description and outline of the work.
2. A contemporaneous time record; do not inflate or invent hours.
3. Relevant scripts, configuration, sanitized output, screenshots, tests, and findings.
4. A short explanation of the learning gained and how results were validated.
5. A stable repository link and commit/release reference where useful.
6. The exact current exam objective(s) the activity supports.
7. Documentation required for the selected CompTIA activity category.

Integrity rules:

- Independent lab work must be labelled as personal/independent work.
- Virtual job simulations are not employment; label them as simulations.
- Synthetic events and controlled attack scenarios are not real incidents or client engagements.
- Planned and incomplete projects must remain identified as such.
- Tool names alone do not prove competence; document the actions and evidence.
- Never claim a rule, script, deployment, or remediation passed unless the test output supports it.
- Remove passwords, API keys, customer details, production logs, and personally identifiable information from public evidence.

## 7. Submission checklist

- [ ] Confirm activity dates fall within the applicable Security+ renewal cycle.
- [ ] Review current official CompTIA CE rules and requirements for the chosen activity category.
- [ ] Confirm the activity type is eligible; a personal portfolio project alone may not qualify.
- [ ] Confirm exam-objective relevance and any current content-alignment threshold.
- [ ] Record actual hours only where the activity category allows or requires hours.
- [ ] Include the category-specific documents CompTIA requires.
- [ ] Test all repository links and ensure evidence supports each claim.
- [ ] Remove secrets and confidential information.
- [ ] Submit through the official CompTIA CE process and retain the receipt and decision.
- [ ] Do not describe a pending activity as approved until CompTIA confirms acceptance.

## 8. Official references

Check current rules, eligible activity categories, documentation requirements, and submission instructions before relying on an activity for renewal:

- [CompTIA — Earn Continuing Education Units](https://www.comptia.org/continuing-education/learn/earn-continuing-education-units)
- [CompTIA Continuing Education program](https://www.comptia.org/continuing-education)

CompTIA makes the final determination. If unsure whether independent lab work or a GitHub portfolio fits an activity category, contact CompTIA CE support before relying on it for renewal.

---

**Document owner:** Hazvinei Nomatter Masiya  
**Review note:** Update this document as activity logs and evidence change. Do not enter a CEU total unless the activity category and current CompTIA rules support it.
