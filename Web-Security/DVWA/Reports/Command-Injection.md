# DVWA Command Injection Vulnerability Report

## Lab Overview

**Project:** Web Application Security Testing Lab  
**Application:** Damn Vulnerable Web Application (DVWA)  
**Vulnerability:** Command Injection  
**Category:** Web Application Security Testing  
**Testing Environment:** Local Cybersecurity Home Lab  

---

# 1. Vulnerability Description

Command Injection is a vulnerability that occurs when a web application executes operating system commands using user-controlled input without proper validation.

An attacker may manipulate application input to execute unauthorized operating system commands on the underlying server.

---

# 2. Testing Environment

| Component | Details |
|---|---|
| Application | DVWA |
| Vulnerability | Command Injection |
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

Command Injection

**Security Level:**

Low

The Command Injection module was selected because it intentionally contains insecure command execution functionality for cybersecurity training.

---

# 4. Testing Methodology

The vulnerability was tested through the DVWA Command Injection module.

Testing process:

1. Accessed the Command Injection page.
2. Submitted a normal input request.
3. Submitted a modified command payload.
4. Observed the server response.
5. Documented the security impact.

---

# 5. Evidence Collection

## Normal Request

A normal request was submitted to the application.

Screenshot:

Web-Security/DVWA/Screenshots/command-injection-normal.png

---

## Successful Command Injection

A modified command was submitted, demonstrating that user input was executed by the server.

Screenshot:

Web-Security/DVWA/Screenshots/command-injection-success.png

---

# 6. Impact Assessment

Successful Command Injection exploitation may allow an attacker to:

- Execute unauthorized commands
- Access server information
- Modify files
- Compromise application confidentiality and integrity
- Gain further access to the system

**Risk Rating: High**

---

# 7. Remediation Recommendations

Recommended security improvements:

- Avoid executing system commands from user input
- Use secure APIs instead of shell commands
- Validate and restrict user input
- Apply least privilege permissions
- Implement application security testing
- Monitor suspicious command execution

---

# 8. Lessons Learned

This lab provided practical experience in:

- Understanding operating system command execution risks
- Identifying insecure application behaviour
- Performing controlled vulnerability testing
- Collecting security evidence
- Writing professional security reports

---

# 9. Evidence Files

| Evidence | Location |
|---|---|
| Normal command request | Web-Security/DVWA/Screenshots/command-injection-normal.png |
| Successful command injection | Web-Security/DVWA/Screenshots/command-injection-success.png |

---

# Conclusion

The DVWA Command Injection assessment demonstrated how unsafe handling of user input can allow attackers to execute operating system commands through a vulnerable web application.

This exercise provided practical experience in vulnerability discovery, exploitation analysis, evidence collection, and remediation recommendations.
