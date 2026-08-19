# DVWA — File Upload

## Objective
Demonstrate identification and exploitation of the File Upload vulnerability in DVWA, and document the finding to professional pentest-report standard.

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
Detection relies on monitoring uploaded file types and extensions against policy and alerting on script files landing in web-accessible directories.

## Triage
Prioritize as critical — a successfully uploaded and executed web shell typically grants persistent remote command execution.

## Investigation
An investigation would review the upload directory for unexpected file types and check web server logs for requests to any newly uploaded files.

## Evidence
_Content for this section should be merged in from the Original Write-Up below._

## Findings
_Content for this section should be merged in from the Original Write-Up below._

## Impact
A successfully uploaded and executed web shell gives the attacker persistent remote command execution on the server.

## Root Cause
Uploaded file type and content are not validated before being stored in a web-accessible, script-executable location.

## MITRE ATT&CK
T1505.003 Server Software Component: Web Shell (Persistence)

## Remediation
Validate file type by content (not extension), store uploads outside the web root, disable script execution in the upload directory, and rename files on upload.

## Validation
_Content for this section should be merged in from the Original Write-Up below._

## Lessons Learned
_Content for this section should be merged in from the Original Write-Up below._

## Recommendations
Beyond the remediation above, scan uploaded files with anti-malware tooling before making them available.

---

## Original Write-Up (preserved as-is — merge relevant details into the sections above, then remove this section)

# DVWA File Upload Vulnerability Report

## Lab Overview

**Project:** Web Application Security Testing Lab  
**Application:** Damn Vulnerable Web Application (DVWA)  
**Vulnerability:** File Upload Vulnerability  
**Category:** Web Application Security Testing  
**Testing Environment:** Local Cybersecurity Home Lab  

---

# 1. Vulnerability Description

File Upload vulnerabilities occur when a web application allows users to upload files without properly validating file type, extension, content, or size.

An attacker may abuse insecure upload functionality to upload malicious files, potentially leading to unauthorized access, remote code execution, or compromise of the web server.

---

# 2. Testing Environment

| Component | Details |
|---|---|
| Application | DVWA |
| Vulnerability | File Upload |
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

File Upload

**Security Level:**

Low

The File Upload module was selected because it intentionally contains weak file validation controls for cybersecurity training and vulnerability assessment practice.

---

# 4. Testing Methodology

The vulnerability was tested using the DVWA File Upload functionality.

Testing process:

1. Accessed the File Upload module.
2. Reviewed the upload functionality.
3. Uploaded a test file.
4. Observed the application response.
5. Documented the security impact.

---

# 5. Evidence Collection

The vulnerability testing evidence was collected using screenshots.

## Upload Page

Screenshot:

Web-Security/DVWA/Screenshots/file-upload-page.png


---

## Successful Upload

A test file was successfully uploaded, demonstrating insufficient file validation controls.

Screenshot:

Web-Security/DVWA/Screenshots/file-upload-success.png

---

# 6. Impact Assessment

Successful exploitation of a File Upload vulnerability may allow an attacker to:

- Upload unauthorized files
- Store malicious content on the server
- Execute server-side scripts
- Compromise application security
- Access sensitive resources

**Risk Rating: High**

---

# 7. Remediation Recommendations

Recommended security improvements:

- Validate uploaded file extensions
- Verify file content using MIME checks
- Rename uploaded files securely
- Store uploads outside the web root
- Restrict executable file uploads
- Implement file size limitations
- Apply proper access controls

---

# 8. Lessons Learned

This lab provided practical experience in:

- Identifying insecure file upload functionality
- Understanding web server upload risks
- Performing controlled security testing
- Collecting vulnerability evidence
- Writing professional security reports

---

# 9. Evidence Files

| Evidence | Location |
|---|---|
| File Upload page | Web-Security/DVWA/Screenshots/file-upload-page.png |
| Successful upload result | Web-Security/DVWA/Screenshots/file-upload-success.png |

---

# Conclusion

The DVWA File Upload assessment demonstrated how weak upload validation can expose web applications to security risks.

This controlled laboratory exercise provided practical experience in vulnerability identification, exploitation analysis, evidence collection, and remediation recommendations.
