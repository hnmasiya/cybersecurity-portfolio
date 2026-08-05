# DVWA SQL Injection Vulnerability Report

## Lab Overview

**Project:** Web Application Security Testing Lab  
**Application:** Damn Vulnerable Web Application (DVWA)  
**Vulnerability:** SQL Injection  
**Category:** Web Application Security Testing  
**Testing Environment:** Local Cybersecurity Home Lab  

---

# 1. Vulnerability Description

SQL Injection is a web application vulnerability that occurs when user-controlled input is processed directly within SQL queries without proper validation or parameterization.

An attacker can manipulate application input fields to modify database queries and access information that should not be publicly available.

---

# 2. Testing Environment

| Component | Details |
|---|---|
| Application | DVWA |
| Vulnerability | SQL Injection |
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

SQL Injection

Security Level:

Low

The SQL Injection module was selected because it intentionally contains insecure database query handling for cybersecurity training and vulnerability assessment practice.

---

# 4. Testing Methodology

The vulnerability was tested using the DVWA SQL Injection module.

Testing process:

1. Accessed the SQL Injection vulnerability page.
2. Submitted a normal User ID request.
3. Submitted a manipulated SQL payload.
4. Compared application responses.
5. Documented the security impact.

---

# 5. Evidence Collection

## Normal Request

A normal request was submitted using:

```text
1
