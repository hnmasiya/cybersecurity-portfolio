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
