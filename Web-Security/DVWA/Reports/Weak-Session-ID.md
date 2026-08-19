# DVWA — Weak Session IDs

## Objective
Demonstrate identification and exploitation of the Weak Session IDs vulnerability in DVWA, and document the finding to professional pentest-report standard.

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
Detection relies on statistical analysis of issued session identifiers for predictability, and monitoring for session reuse across unrelated source IPs.

## Triage
Prioritize based on the sensitivity of the account/session data reachable once a session is hijacked.

## Investigation
An investigation would review session logs for concurrent use of the same session ID from different IP addresses or user agents.

## Evidence
_Content for this section should be merged in from the Original Write-Up below._

## Findings
_Content for this section should be merged in from the Original Write-Up below._

## Impact
Predictable session identifiers allow an attacker to guess or forge a valid session and hijack another user's authenticated session.

## Root Cause
Session identifiers are generated using a predictable algorithm rather than a cryptographically secure random source.

## MITRE ATT&CK
T1539 Steal Web Session Cookie (Credential Access)

## Remediation
Generate session identifiers using a cryptographically secure random number generator with sufficient entropy, and rotate the session ID on login.

## Validation
_Content for this section should be merged in from the Original Write-Up below._

## Lessons Learned
_Content for this section should be merged in from the Original Write-Up below._

## Recommendations
Beyond the remediation above, set the Secure and HttpOnly flags on session cookies to reduce exposure.

---

## Original Write-Up (preserved as-is — merge relevant details into the sections above, then remove this section)

# DVWA Weak Session ID Vulnerability Report

## Lab Overview

**Project:** Web Application Security Testing Lab  
**Application:** Damn Vulnerable Web Application (DVWA)  
**Vulnerability:** Weak Session ID  
**Category:** Web Application Security Testing  
**Testing Environment:** Local Cybersecurity Home Lab

---

# 1. Vulnerability Description

Weak Session ID vulnerabilities occur when a web application generates predictable or insufficiently random session identifiers.

If session IDs can be guessed or predicted, an attacker may hijack another user's authenticated session without knowing their credentials.

---

# 2. Testing Environment

| Component | Details |
|---|---|
| Application | DVWA |
| Vulnerability | Weak Session ID |
| Security Level | Low |
| Operating System | Zorin OS |
| Web Server | Apache 2.4.58 (Ubuntu) |
| Database | MariaDB 10.11.14 |
| PHP Version | PHP 8.3.6 |
| Testing Tools | Browser |

---

# 3. Vulnerable Application Component

## DVWA Module

**Target:**

Weak Session IDs

**Security Level:**

Low

The Weak Session ID module intentionally generates predictable session identifiers for security awareness and testing purposes.

---

# 4. Testing Methodology

The vulnerability was tested using the DVWA Weak Session ID module.

Testing process:

1. Opened the Weak Session ID module.
2. Generated multiple session identifiers.
3. Observed the generated values.
4. Compared the identifiers for predictability.
5. Documented the security implications.

---

# 5. Evidence Collection

The vulnerability was demonstrated by generating multiple session identifiers.

## Weak Session ID Page

Screenshot:

Web-Security/DVWA/Screenshots/weak-session-page.png

---

## Session ID Analysis

Multiple generated session IDs followed a predictable pattern, demonstrating weak randomness.

Screenshot:

Web-Security/DVWA/Screenshots/weak-session-analysis.png

---

# 6. Impact Assessment

Weak session identifiers may allow an attacker to:

- Predict valid session IDs
- Hijack authenticated user sessions
- Access sensitive application data
- Bypass authentication controls

**Risk Rating: Medium**

---

# 7. Remediation Recommendations

Recommended security improvements:

- Use cryptographically secure random session identifiers
- Regenerate session IDs after successful authentication
- Configure secure and HttpOnly cookies
- Enable the SameSite cookie attribute
- Expire inactive sessions after a defined timeout
- Monitor for suspicious session activity

---

# 8. Lessons Learned

This lab provided practical experience in:

- Understanding session management vulnerabilities
- Identifying predictable session identifiers
- Assessing authentication security
- Collecting security evidence
- Writing professional vulnerability reports

---

# 9. Evidence Files

| Evidence | Location |
|---|---|
| Weak Session ID page | Web-Security/DVWA/Screenshots/weak-session-page.png |
| Session ID analysis | Web-Security/DVWA/Screenshots/weak-session-analysis.png |

---

# Conclusion

The DVWA Weak Session ID assessment demonstrated how predictable session identifiers can weaken authentication security and increase the risk of session hijacking.

This controlled laboratory exercise provided practical experience in identifying session management weaknesses, analyzing their security impact, collecting evidence, and documenting findings using industry-standard reporting practices.
