# OWASP Juice Shop JWT Token Analysis Report

## Lab Overview

**Project:** Web Application Security Testing Lab  
**Application:** OWASP Juice Shop  
**Vulnerability Area:** Authentication / JWT Security  
**Testing Tool:** Burp Suite Community Edition  
**Environment:** Local Cybersecurity Home Lab  

---

# 1. Objective

The objective of this assessment was to analyse the JSON Web Token (JWT) implementation used by OWASP Juice Shop authentication.

---

# 2. Testing Environment

| Component | Details |
|---|---|
| Application | OWASP Juice Shop |
| Platform | Docker |
| Operating System | Zorin OS |
| Testing Tool | Burp Suite Community Edition |

---

# 3. Testing Methodology

Testing steps:

1. Authenticated to Juice Shop.
2. Intercepted login request using Burp Suite.
3. Captured JWT authentication token.
4. Decoded token structure.
5. Reviewed token claims.

---

# 4. JWT Analysis

The authentication response returned a JWT token containing:

- Header information
- Algorithm details
- User claims
- Authentication information

---

# 5. Evidence

Screenshots:

- jwt-login-response.png

Location:


---

# 6. Security Considerations

JWT implementations should ensure:

- Strong signing algorithms
- Secure secret keys
- Proper token expiration
- Token validation
- Secure storage

---

# 7. Recommendations

Recommended improvements:

- Rotate signing keys regularly
- Avoid weak algorithms
- Implement short token lifetimes
- Validate all token claims
- Use secure cookie settings

---

# Conclusion

This exercise provided practical experience analysing JWT authentication mechanisms using Burp Suite and OWASP Juice Shop.
