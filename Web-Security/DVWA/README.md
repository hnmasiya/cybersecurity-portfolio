# DVWA Web Application Security Lab

## Overview

This directory documents controlled security assessments performed against the Damn Vulnerable Web Application (DVWA) in a local cybersecurity laboratory.

The purpose of the project is to demonstrate practical skills in:

- Web application security testing
- Vulnerability identification
- Controlled exploitation
- HTTP request analysis
- Authentication testing
- Session security assessment
- SQL injection testing
- Evidence collection
- Security triage
- Detection engineering
- Remediation planning
- Professional security reporting

## Laboratory Environment

| Component | Details |
|---|---|
| Host OS | Zorin OS |
| Web Server | Apache 2.4.58 (Ubuntu) |
| PHP | 8.3.6 |
| Database | MariaDB 10.11.14 |
| Application | DVWA |
| Testing Tools | Browser, Burp Suite Community Edition, Linux tools |
| Scope | Local controlled laboratory |

## Vulnerability Reports

| Report | Vulnerability |
|---|---|
| [Brute Force](Reports/Brute-Force.md) | Authentication / Credential Access |
| [Command Injection](Reports/Command-Injection.md) | Command Execution |
| [CSRF](Reports/CSRF.md) | Cross-Site Request Forgery |
| [File Inclusion](Reports/File-Inclusion.md) | LFI/RFI |
| [File Upload](Reports/File-Upload.md) | Insecure File Upload |
| [SQL Injection](Reports/SQL-Injection.md) | Database Injection |
| [Weak Session ID](Reports/Weak-Session-ID.md) | Session Management |

## Methodology

Each assessment follows a repeatable structure:

1. Objective
2. Skills and tools
3. Architecture
4. Topology
5. Execution
6. Walkthrough
7. Attack simulation
8. Detection
9. Triage
10. Investigation
11. Evidence
12. Findings
13. Impact
14. Root cause
15. MITRE ATT&CK mapping
16. Remediation
17. Validation
18. Lessons learned
19. Recommendations

## Scope and Ethics

All testing documented here was conducted against a deliberately vulnerable application in a controlled local laboratory environment. The techniques are intended for authorized security testing, education, and defensive security research.


---

# 20-Section Evidence-First Case Study Record

> Permanent case-study standard mapping. Existing content and artifacts remain authoritative; this section introduces no new execution claims.

**Evidence state:** LIVE / REAL LAB

## 1. Scenario
Use only the documented scenario above.
## 2. Business / Technical Context
Use only the documented technical/training context; no production impact is inferred.
## 3. Objective
Use the documented objective without expanding scope.
## 4. Environment / Scope
Only explicitly documented systems, datasets, services, simulations, and authorized infrastructure are in scope.
## 5. Tools Used
Only tools evidenced by documentation or retained artifacts are treated as used.
## 6. Investigation / Methodology
Follow the documented acquisition/generation, validation, analysis, interpretation, and reporting workflow.
## 7. Commands / Scripts Used
Existing commands and scripts remain authoritative; code existence alone is not execution evidence.
## 8. Evidence
Only retained and referenced datasets, screenshots, reports, rules, scripts, outputs, and logs are evidence.
## 9. Indicators / Observations
Only recorded observations are presented; synthetic indicators remain synthetic.
## 10. Analysis
Separate observations from interpretation and preserve supported benign explanations.
## 11. Findings
Only findings supported by retained evidence are stated.
## 12. Risk / Impact
Scope risk to the lab; do not infer customer, employer, breach, or production impact.
## 13. Recommended Actions
Recommendations follow from documented findings and validation gaps.
## 14. Detection / Monitoring Opportunities
Only demonstrated or explicitly proposed opportunities are presented; unexecuted work remains pending.
## 15. MITRE ATT&CK Mapping
Retain only justified existing mappings.
## 16. Lessons Learned
Derive lessons from documented execution, troubleshooting, validation, and methodology.
## 17. Skills Demonstrated
Claim only skills evidenced by retained work.
## 18. Portfolio / SOC Relevance
Map the evidence to the relevant security workflow without overstating professional experience.
## 19. Evidence & Limitations
**LIVE / REAL LAB.** Preserve dataset, environment, telemetry, and unperformed-step limitations.
## 20. References / Source Material
Existing linked artifacts, reports, scripts, datasets, standards, and source material remain authoritative.

### Evidence Integrity Statement
No fabricated metrics, incidents, certifications, production claims, or execution results are introduced.
