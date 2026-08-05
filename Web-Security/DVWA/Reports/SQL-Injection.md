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

**Target:**

SQL Injection

**Security Level:**

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

The vulnerability was successfully demonstrated using the DVWA SQL Injection module.

## Normal Request

A normal request was submitted using:

1

Screenshot:

Web-Security/DVWA/Screenshots/sql-injection-normal.png

---

## SQL Injection Payload

The following SQL injection payload was submitted:

1' OR '1'='1

Result:

The application returned multiple database records, confirming that the input field was vulnerable to SQL Injection.

Screenshot:

Web-Security/DVWA/Screenshots/sql-injection-success.png

---

# 6. Impact Assessment

Successful SQL Injection exploitation may allow an attacker to:

- Retrieve unauthorized database records
- Access sensitive information
- Bypass authentication controls
- Modify or delete database data
- Compromise confidentiality and integrity of application data

**Risk Rating: High**

---

# 7. Remediation Recommendations

Recommended security improvements:

- Use prepared statements and parameterized queries
- Implement strict input validation
- Sanitize user-controlled input
- Apply least privilege database permissions
- Avoid displaying database errors to users
- Perform regular vulnerability assessments
- Conduct secure code reviews

---

# 8. Lessons Learned

This lab provided practical experience in:

- Identifying SQL Injection vulnerabilities
- Understanding insecure database interactions
- Performing controlled exploitation testing
- Collecting security evidence
- Writing professional vulnerability reports
- Recommending remediation actions

---

# 9. Evidence Files

The following evidence was collected:

| Evidence | Location |
|---|---|
| Normal SQL Injection page | Web-Security/DVWA/Screenshots/sql-injection-normal.png |
| Successful SQL Injection result | Web-Security/DVWA/Screenshots/sql-injection-success.png |

---

# Conclusion

The DVWA SQL Injection assessment demonstrated how improper handling of user input can expose web applications to database attacks.

This controlled laboratory exercise provided practical experience in vulnerability identification, exploitation analysis, evidence collection, and professional security documentation.
