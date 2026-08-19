# DVWA — Brute Force

## Objective
Demonstrate identification and exploitation of the Brute Force vulnerability in DVWA, and document the finding to professional pentest-report standard.

## Skills & Tools
DVWA, web browser developer tools, manual HTTP request crafting, Linux, Git.

## Architecture
DVWA is a deliberately vulnerable PHP/MySQL web application, run here via Docker Compose on a Zorin OS lab host, used to safely practice identifying and exploiting common web vulnerabilities.

## Topology
Target: DVWA at http://localhost:8081, part of the local Docker-based cyberlab environment.

## Execution
_Content for this section should be merged in from the Original Write-Up below._

## Walkthrough
_Content for this section should be merged in from the Original Write-Up below._

## Attack Simulation
_Content for this section should be merged in from the Original Write-Up below._

## Detection
Detection relies on monitoring for a high rate of failed authentication attempts against a single account or from a single source within a short window.

## Triage
Prioritize based on whether the targeted account has elevated privileges and whether the login endpoint is internet-facing.

## Investigation
An investigation would review authentication logs for the volume and timing of failed attempts and cross-reference the source IP against known scanning infrastructure.

## Evidence
_Content for this section should be merged in from the Original Write-Up below._

## Findings
_Content for this section should be merged in from the Original Write-Up below._

## Impact
A successful brute force yields valid credentials, giving the attacker the same access as the legitimate account holder.

## Root Cause
The application does not implement any control to slow or block repeated authentication attempts against the same account.

## MITRE ATT&CK
T1110 Brute Force (Credential Access)

## Remediation
Implement account lockout or exponential backoff after repeated failed attempts, add CAPTCHA after a threshold, and enforce multi-factor authentication.

## Validation
_Content for this section should be merged in from the Original Write-Up below._

## Lessons Learned
_Content for this section should be merged in from the Original Write-Up below._

## Recommendations
Beyond the remediation above, consider multi-factor authentication and alerting on failed-login thresholds.

---

## Original Write-Up (preserved as-is — merge relevant details into the sections above, then remove this section)

# DVWA Brute Force Vulnerability Report

## Lab Overview

**Project:** Web Application Security Testing Lab  
**Application:** Damn Vulnerable Web Application (DVWA)  
**Vulnerability:** Brute Force Attack  
**Category:** Authentication Security Testing  
**Testing Environment:** Local Cybersecurity Home Lab  

---

# 1. Vulnerability Description

A Brute Force vulnerability occurs when an application does not properly protect authentication mechanisms against repeated login attempts.

An attacker may repeatedly submit username and password combinations until valid credentials are discovered.

Common weaknesses include:

- No account lockout mechanism
- No login attempt limitation
- Weak password policies
- Missing multi-factor authentication controls

---

# 2. Testing Environment

| Component | Details |
|---|---|
| Application | DVWA |
| Vulnerability | Brute Force |
| Security Level | Low |
| Operating System | Zorin OS |
| Web Server | Apache 2.4.58 (Ubuntu) |
| Database | MariaDB 10.11.14 |
| PHP Version | PHP 8.3.6 |
| Testing Tools | Browser, Burp Suite Community Edition |

---

# 3. Vulnerable Application Component

## DVWA Module

**Target:**

Brute Force

**Security Level:**

Low

The Brute Force module was selected because it intentionally contains weak authentication controls for cybersecurity training and vulnerability assessment practice.

---

# 4. Testing Methodology

The vulnerability was tested using the DVWA Brute Force module.

Testing process:

1. Accessed the Brute Force page.
2. Reviewed the login functionality.
3. Submitted incorrect credentials.
4. Tested repeated authentication attempts.
5. Identified the absence of effective brute force protection.
6. Documented the security impact.

---

# 5. Evidence Collection

The vulnerability testing evidence was collected using screenshots.

## Brute Force Page

Screenshot:

Web-Security/DVWA/Screenshots/brute-force-page.png

---

## Successful Authentication

A valid username and password combination was discovered during testing, demonstrating weak authentication controls.

Screenshot:

Web-Security/DVWA/Screenshots/brute-force-success.png

---

# 6. Impact Assessment

Successful brute force attacks may allow an attacker to:

- Gain unauthorized account access
- Compromise user accounts
- Access sensitive application information
- Perform further attacks using valid credentials

**Risk Rating: High**

---

# 7. Remediation Recommendations

Recommended security improvements:

- Implement account lockout policies
- Add login attempt rate limiting
- Use multi-factor authentication
- Enforce strong password policies
- Monitor failed login attempts
- Implement CAPTCHA after repeated failures

---

# 8. Lessons Learned

This lab provided practical experience in:

- Understanding authentication weaknesses
- Testing login security controls
- Identifying brute force risks
- Collecting security evidence
- Writing vulnerability reports

---

# 9. Evidence Files

| Evidence | Location |
|---|---|
| Brute Force page | Web-Security/DVWA/Screenshots/brute-force-page.png |
| Successful authentication | Web-Security/DVWA/Screenshots/brute-force-success.png |

---

# Conclusion

The DVWA Brute Force assessment demonstrated how weak authentication controls can expose applications to unauthorized access attempts.

This controlled laboratory exercise provided practical experience in authentication testing, vulnerability identification, evidence collection, and security remediation.
