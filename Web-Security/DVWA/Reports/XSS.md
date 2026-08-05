# DVWA Cross-Site Scripting (XSS) Vulnerability Report

## Lab Overview

**Project:** Web Application Security Testing Lab  
**Application:** Damn Vulnerable Web Application (DVWA)  
**Vulnerability:** Cross-Site Scripting (XSS)  
**Category:** Web Application Security Testing  
**Testing Environment:** Local Cybersecurity Home Lab  

---

# 1. Vulnerability Description

Cross-Site Scripting (XSS) is a web application vulnerability that occurs when an application accepts untrusted user input and displays it in a browser without proper validation or output encoding.

An attacker can inject malicious scripts that execute in another user's browser session.

---

# 2. Testing Environment

| Component | Details |
|---|---|
| Application | DVWA |
| Vulnerability | Cross-Site Scripting (XSS) |
| Security Level | Low |
| Operating System | Zorin OS |
| Web Server | Apache 2.4.58 (Ubuntu) |
| Database | MariaDB 10.11.14 |
| PHP Version | PHP 8.3.6 |
| Testing Tools | Browser, Burp Suite Community Edition |

---

# 3. Vulnerable Application Component

## DVWA Module

Target:

Cross-Site Scripting (XSS)

Security Level:

Low

The XSS module was selected because it intentionally contains weak input validation for security training and vulnerability assessment practice.

---

# 4. Testing Methodology

The vulnerability was tested using the DVWA XSS module.

Testing process:

1. Accessed the XSS vulnerability page.
2. Identified the vulnerable input field.
3. Submitted a JavaScript payload.
4. Observed browser execution.
5. Captured evidence screenshots.

---

# 5. Evidence Collection

The vulnerability was demonstrated by injecting JavaScript code into the vulnerable input field.

## XSS Payload

Payload submitted:

<script>alert('XSS')</script>

Result:

The JavaScript payload executed successfully in the browser, confirming the presence of a Cross-Site Scripting vulnerability.

Screenshots:

Web-Security/DVWA/Screenshots/xss-payload.png

Web-Security/DVWA/Screenshots/xss-success.png

---

# 6. Impact Assessment

Successful XSS exploitation may allow an attacker to:

- Execute malicious scripts in a victim's browser
- Steal session cookies
- Perform actions on behalf of users
- Redirect users to malicious websites
- Capture sensitive information

Risk Rating:

Medium to High

---

# 7. Remediation Recommendations

Recommended security improvements:

- Implement proper input validation
- Encode output before displaying user data
- Use Content Security Policy (CSP)
- Sanitize user-controlled input
- Avoid directly inserting user input into HTML responses
- Conduct regular web application security testing

---

# 8. Lessons Learned

This lab provided practical experience in:

- Identifying XSS vulnerabilities
- Understanding client-side attacks
- Testing insecure input handling
- Collecting security evidence
- Documenting vulnerabilities professionally

---

# 9. Evidence Files

| Evidence | Location |
|---|---|
| XSS payload submission | Web-Security/DVWA/Screenshots/xss-payload.png |
| Successful XSS execution | Web-Security/DVWA/Screenshots/xss-success.png |

---

# Conclusion

The DVWA Cross-Site Scripting assessment demonstrated how improper handling of user input can allow malicious scripts to execute in a user's browser.

This exercise provided practical experience in vulnerability discovery, exploitation analysis, evidence collection, and security remediation.
