# OWASP Juice Shop SQL Injection Assessment Report

## Lab Overview

**Project:** Web Application Security Testing Lab  
**Application:** OWASP Juice Shop  
**Vulnerability:** SQL Injection  
**Testing Tool:** Burp Suite Community Edition  
**Environment:** Local Cybersecurity Home Lab  

---

# 1. Vulnerability Description

SQL Injection occurs when an application fails to properly validate user input before processing database queries.

Attackers may manipulate SQL statements to bypass authentication or access unauthorized information.

---

# 2. Testing Methodology

Testing steps:

1. Accessed Juice Shop login functionality.
2. Captured authentication request using Burp Suite.
3. Modified user input parameters.
4. Submitted SQL injection payload.
5. Analysed application response.

---

# 3. Payload Tested

---

# 4. Result

The application response was analysed to determine whether user input could influence authentication queries.

---

# 5. Evidence

Screenshots:

- sql-injection-request.png
- sql-injection-success.png

Location:

---

# 6. Impact

Successful SQL Injection may allow:

- Authentication bypass
- Unauthorized database access
- Information disclosure
- Data manipulation

Risk Rating:

High

---

# 7. Remediation

Recommendations:

- Use prepared statements
- Implement parameterized queries
- Validate user input
- Apply secure coding practices
- Conduct regular security testing

---

# Conclusion

This assessment demonstrated SQL Injection testing against a modern intentionally vulnerable web application using Burp Suite.
