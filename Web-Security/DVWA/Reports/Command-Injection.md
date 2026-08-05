# DVWA Command Injection Vulnerability Report

## Lab Overview

**Project:** Web Application Security Testing Lab  
**Application:** Damn Vulnerable Web Application (DVWA)  
**Vulnerability:** Command Injection  
**Category:** Web Application Security Testing  
**Testing Environment:** Local Cybersecurity Home Lab  

---

# 1. Vulnerability Description

Command Injection is a web application vulnerability that occurs when an application executes operating system commands using user-controlled input without proper validation or sanitization.

An attacker can manipulate input fields to execute unauthorized system commands on the underlying server.

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

Target:

Command Injection

Security Level:

Low

The Command Injection module was selected because it intentionally contains insecure handling of user input for cybersecurity training and vulnerability assessment practice.

---

# 4. Testing Methodology

The vulnerability was tested using the DVWA Command Injection module.

Testing process:

1. Accessed the Command Injection page.
2. Identified the vulnerable input parameter.
3. Submitted a normal command request.
4. Submitted a modified command payload.
5. Observed command execution results.
6. Captured evidence screenshots.

---

# 5. Evidence Collection

The vulnerability was demonstrated by injecting operating system commands into the vulnerable input field.

## Normal Request

Command submitted:

ping -c 1 127.0.0.1

Screenshot:

Web-Security/DVWA/Screenshots/command-injection-normal.png

---

## Command Injection Payload

Payload submitted:

127.0.0.1 && whoami

Result:

The application executed the additional operating system command and returned the server username, confirming Command Injection.

Screenshot:

Web-Security/DVWA/Screenshots/command-injection-success.png

---

# 6. Impact Assessment

Successful Command Injection exploitation may allow an attacker to:

- Execute arbitrary operating system commands
- Access sensitive server information
- Modify system files
- Escalate privileges
- Compromise the underlying server

Risk Rating:

High

---

# 7. Remediation Recommendations

Recommended security improvements:

- Avoid executing system commands from user input
- Implement strict input validation
- Use allowlists for accepted input values
- Apply least privilege permissions
- Sanitize all user-controlled data
- Monitor application logs for suspicious activity

---

# 8. Lessons Learned

This lab provided practical experience in:

- Understanding operating system command execution risks
- Identifying insecure input handling
- Performing controlled exploitation testing
- Collecting security evidence
- Writing professional vulnerability reports

---

# 9. Evidence Files

| Evidence | Location |
|---|---|
| Normal command execution | Web-Security/DVWA/Screenshots/command-injection-normal.png |
| Successful command injection | Web-Security/DVWA/Screenshots/command-injection-success.png |

---

# Conclusion

The DVWA Command Injection assessment demonstrated how insecure handling of user input can allow attackers to execute unauthorized operating system commands.

This exercise provided practical experience in vulnerability identification, exploitation analysis, evidence collection, and security remediation.
