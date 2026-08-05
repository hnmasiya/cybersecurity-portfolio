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
