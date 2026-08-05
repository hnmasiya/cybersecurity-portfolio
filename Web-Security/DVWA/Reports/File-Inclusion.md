# DVWA File Inclusion Vulnerability Report

## Lab Overview

**Project:** Web Application Security Testing Lab  
**Application:** Damn Vulnerable Web Application (DVWA)  
**Vulnerability:** File Inclusion (LFI/RFI)  
**Category:** Web Application Security Testing  
**Testing Environment:** Local Cybersecurity Home Lab  

---

# 1. Vulnerability Description

File Inclusion vulnerabilities occur when a web application allows users to include files through untrusted input parameters without proper validation.

Two common types include:

## Local File Inclusion (LFI)

LFI allows an attacker to access files stored locally on the web server.

Examples of potentially exposed files:

- Configuration files
- System files
- Application source code

## Remote File Inclusion (RFI)

RFI occurs when an application allows external files from remote locations to be included and executed.

---

# 2. Testing Environment

| Component | Details |
|---|---|
| Application | DVWA |
| Vulnerability | File Inclusion |
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

File Inclusion

**Security Level:**

Low

The File Inclusion module was selected because it intentionally contains insecure file handling functionality for cybersecurity training and vulnerability assessment practice.

---

# 4. Testing Methodology

The vulnerability was tested using the DVWA File Inclusion module.

Testing process:

1. Accessed the File Inclusion page.
2. Reviewed the file parameter used by the application.
3. Tested file path manipulation.
4. Observed application responses.
5. Documented the security impact.

---

# 5. Evidence Collection

The vulnerability testing evidence was collected using screenshots.

## File Inclusion Page

Screenshot:

Web-Security/DVWA/Screenshots/file-inclusion-page.png

---

## Successful File Inclusion

A manipulated file path was processed by the application, demonstrating insufficient input validation.

Screenshot:

Web-Security/DVWA/Screenshots/file-inclusion-success.png

---

# 6. Impact Assessment

Successful File Inclusion exploitation may allow an attacker to:

- Access sensitive server files
- Read application configuration files
- Expose credentials and secrets
- Execute unauthorized files (depending on configuration)
- Compromise application confidentiality

**Risk Rating: High**

---

# 7. Remediation Recommendations

Recommended security improvements:

- Avoid using user input directly in file paths
- Implement strict allow-list validation
- Disable remote file inclusion settings
- Use secure file handling methods
- Restrict application permissions
- Perform regular security testing

---

# 8. Lessons Learned

This lab provided practical experience in:

- Understanding file path security risks
- Identifying insecure file inclusion behaviour
- Performing controlled vulnerability testing
- Collecting security evidence
- Writing professional vulnerability reports

---

# 9. Evidence Files

| Evidence | Location |
|---|---|
| File Inclusion page | Web-Security/DVWA/Screenshots/file-inclusion-page.png |
| Successful File Inclusion result | Web-Security/DVWA/Screenshots/file-inclusion-success.png |

---

# Conclusion

The DVWA File Inclusion assessment demonstrated how improper handling of file paths can expose web applications to unauthorized file access.

This controlled laboratory exercise provided practical experience in vulnerability discovery, exploitation analysis, evidence collection, and remediation recommendations.
