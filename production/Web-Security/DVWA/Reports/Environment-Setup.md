# DVWA Environment Setup Report

## Lab Overview

**Project:** Web Application Security Testing Lab  
**Application:** Damn Vulnerable Web Application (DVWA)  
**Category:** Web Security / Vulnerability Assessment  
**Environment:** Local Cybersecurity Home Lab  

## Purpose

The purpose of this lab is to deploy and configure DVWA as a controlled vulnerable web application environment for practicing web application security testing techniques, including vulnerability identification, exploitation, and remediation analysis.

---

# 1. Lab Environment

## Host System

| Component | Details |
|---|---|
| Operating System | Zorin OS |
| Web Application | Damn Vulnerable Web Application (DVWA) |
| Web Server | Apache 2.4.58 (Ubuntu) |
| Database | MariaDB 10.11.14 |
| PHP Version | PHP 8.3.6 |
| Security Testing Tools | Burp Suite Community Edition, Nmap, Wireshark |
---

# 2. DVWA Deployment

DVWA was deployed in a controlled local environment to provide a safe platform for learning and practicing web application security testing.

## Installation Method

Deployment components:

- Apache web server
- PHP runtime environment
- MariaDB database backend
- DVWA application files hosted locally

## DVWA Installation Location

The DVWA application was deployed under the Apache web root directory:

```bash
/var/www/html/dvwa
```

Verified web directory:

```text
/var/www/html/

├── dvwa
└── index.html
```

---

# 3. Service Verification

Before accessing DVWA, the required services were verified.

## Apache Web Server

Command used:

```bash
sudo systemctl status apache2
```

Expected status:

```text
Active: active (running)
```

Apache version:

```text
Apache/2.4.58 (Ubuntu)
```

---

## MariaDB Database

Command used:

```bash
sudo systemctl status mariadb
```

Expected status:

```text
Active: active (running)
```

MariaDB version:

```text
MariaDB 10.11.14
```

Database server confirmation:

```text
ready for connections
```

---

# 4. DVWA Access Verification

DVWA was accessed through the local browser:

```text
http://localhost/dvwa
```

The DVWA login page successfully loaded, confirming:

- Apache configuration was successful
- PHP processing was working
- Database connectivity was available
- DVWA deployment was successful

---

# 5. DVWA Security Configuration

DVWA provides different security difficulty levels to simulate different application security conditions.

| Security Level | Description |
|---|---|
| Low | Minimal protection, used for vulnerability learning |
| Medium | Partial security filtering and validation |
| High | Stronger security controls |

Current testing level:

```text
Low
```

---

# 6. Testing Scope

The following vulnerabilities will be investigated during this lab:

## Web Application Vulnerabilities

- SQL Injection
- Cross-Site Scripting (XSS)
- Command Injection
- File Inclusion
- File Upload Vulnerabilities
- Brute Force Attacks
- Cross-Site Request Forgery (CSRF)
- Authentication weaknesses

---

# 7. Security Testing Tools

The following tools will be used:

| Tool | Purpose |
|---|---|
| Burp Suite Community Edition | Web request interception and analysis |
| Nmap | Network and service enumeration |
| Wireshark | Network traffic analysis |
| Browser Developer Tools | Web debugging and inspection |

---

# 8. Evidence Collection

## DVWA Login Page

A screenshot will be captured to confirm successful deployment.

Screenshot location:

```text
Web-Security/DVWA/Screenshots/dvwa-login.png
```

---

# 9. Lessons Learned

This lab provides practical experience in:

- Deploying vulnerable web applications
- Understanding web application vulnerabilities
- Performing controlled security testing
- Using penetration testing tools
- Documenting security findings professionally

---

# 10. Next Steps

Future DVWA testing activities:

1. SQL Injection vulnerability testing
2. Cross-Site Scripting testing
3. Brute Force testing
4. File Upload testing
5. Vulnerability reporting
6. Security remediation recommendations

---

# Conclusion

The DVWA environment was successfully deployed as part of a cybersecurity home laboratory. The environment provides a safe platform for practicing web application security testing techniques and documenting vulnerabilities using industry-standard methodologies.
