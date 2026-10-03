# OWASP Juice Shop Authentication Testing Report

## Lab Overview

**Project:** Web Application Security Testing Lab  
**Application:** OWASP Juice Shop  
**Vulnerability Area:** Authentication Security  
**Testing Tool:** Burp Suite Community Edition  

---

# 1. Objective

The objective of this assessment was to analyze the login functionality and identify weaknesses in authentication controls.

---

# 2. Testing Environment

| Component | Details |
|---|---|
| Application | OWASP Juice Shop |
| Platform | Docker |
| Testing Tool | Burp Suite Community Edition |
| Security Level | Training Environment |

---

# 3. Testing Methodology

Testing included:

- Accessing the login page
- Capturing authentication requests
- Reviewing login parameters
- Analysing server responses

---

# 4. Evidence

Screenshots:

- login-page.png
- login-request.png
- login-failed.png

---

# 5. Findings

The authentication mechanism was reviewed to understand:

- Login request structure
- Credential handling
- Server response behaviour

---

# 6. Recommendations

Recommended security controls:

- Implement strong authentication controls
- Enforce MFA
- Apply rate limiting
- Monitor failed login attempts
- Use secure password storage mechanisms

---

# Conclusion

The authentication testing exercise provided practical experience in analysing web application login security using Burp Suite.
