# DVWA — CSRF

## Objective
Demonstrate identification and exploitation of the CSRF vulnerability in DVWA, and document the finding to professional pentest-report standard.

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
Detection relies on monitoring for state-changing requests that arrive without an expected anti-CSRF token or with a mismatched Origin/Referer header.

## Triage
Prioritize based on the sensitivity of the action the forged request can trigger, such as a password or email change.

## Investigation
An investigation would review the referring page and headers of the state-changing request and confirm whether token validation was actually enforced.

## Evidence
_Content for this section should be merged in from the Original Write-Up below._

## Findings
_Content for this section should be merged in from the Original Write-Up below._

## Impact
A successful CSRF attack can change account credentials or settings on the victim's behalf, potentially locking them out or enabling account takeover.

## Root Cause
State-changing requests are not bound to a per-session token, so the server cannot distinguish a legitimate request from a forged one.

## MITRE ATT&CK
T1190 Exploit Public-Facing Application (Initial Access)

## Remediation
Implement per-session anti-CSRF tokens on all state-changing forms and validate the Origin/Referer header server-side.

## Validation
_Content for this section should be merged in from the Original Write-Up below._

## Lessons Learned
_Content for this section should be merged in from the Original Write-Up below._

## Recommendations
Beyond the remediation above, apply the SameSite cookie attribute to reduce cross-site request exposure.

---

## Original Write-Up (preserved as-is — merge relevant details into the sections above, then remove this section)

# DVWA CSRF Vulnerability Report

## Lab Overview

**Project:** Web Application Security Testing Lab  
**Application:** Damn Vulnerable Web Application (DVWA)  
**Vulnerability:** Cross-Site Request Forgery (CSRF)  
**Category:** Web Application Security Testing  
**Testing Environment:** Local Cybersecurity Home Lab  

---

# 1. Vulnerability Description

Cross-Site Request Forgery (CSRF) is a vulnerability where an attacker tricks an authenticated user into performing an unwanted action without their knowledge.

The attack abuses the user's active session and sends unauthorized requests to the vulnerable application.

---

# 2. Testing Environment

| Component | Details |
|---|---|
| Application | DVWA |
| Vulnerability | CSRF |
| Security Level | Low |
| Operating System | Zorin OS |
| Web Server | Apache 2.4.58 (Ubuntu) |
| Database | MariaDB 10.11.14 |
| PHP Version | PHP 8.3.6 |
| Testing Tools | Browser |

---

# 3. Vulnerable Application Component

## DVWA Module

Target:

CSRF

Security Level:

Low

The CSRF module was selected because it intentionally lacks CSRF protection mechanisms for security training.

---

# 4. Testing Methodology

Testing steps:

1. Accessed the DVWA CSRF module.
2. Changed the password normally.
3. Observed the password change request.
4. Created a malicious request containing password parameters.
5. Confirmed that the application accepted unauthorized requests.

---

# 5. Evidence Collection

## Normal Password Change

Screenshot:

Web-Security/DVWA/Screenshots/csrf-normal.png


---

## Successful CSRF Test

Screenshot:

Web-Security/DVWA/Screenshots/csrf-success.png


---

# 6. Impact Assessment

Successful CSRF attacks may allow attackers to:

- Change user account settings
- Modify sensitive information
- Perform unauthorized actions
- Compromise user accounts

Risk Rating:

Medium/High

---

# 7. Remediation Recommendations

Recommended fixes:

- Implement CSRF tokens
- Validate request origin
- Use SameSite cookie attributes
- Require user confirmation for sensitive actions
- Apply secure session management

---

# 8. Lessons Learned

This lab provided practical experience in:

- Understanding CSRF attacks
- Testing authenticated web applications
- Identifying missing security controls
- Documenting vulnerabilities professionally

---

# Conclusion

The DVWA CSRF assessment demonstrated how missing request validation can allow unauthorized actions to be performed using an authenticated user's session.

The exercise provided practical experience in vulnerability discovery, testing, evidence collection, and remediation recommendations.
