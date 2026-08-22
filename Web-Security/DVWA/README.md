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
