# OWASP Juice Shop Authentication Assessment

## Lab Overview

**Project:** Modern Web Application Security Testing  
**Application:** OWASP Juice Shop  
**Assessment:** Authentication Testing  
**Category:** Authentication Security  
**Testing Environment:** Local Cybersecurity Home Lab  

---

# 1. Objective

The objective of this assessment is to evaluate the authentication functionality of OWASP Juice Shop by observing the login workflow, account registration process, and application responses to valid and invalid authentication attempts.

---

# 2. Testing Environment

| Component | Details |
|---|---|
| Operating System | Zorin OS |
| Application | OWASP Juice Shop |
| Deployment | Docker |
| Browser | Firefox |
| URL | http://localhost:3000 |

---

# 3. Testing Methodology

The authentication functionality was evaluated using the following process:

1. Accessed the Juice Shop login page.
2. Created a new test user account.
3. Performed a successful login.
4. Performed an unsuccessful login using incorrect credentials.
5. Observed application responses.
6. Documented authentication behaviour.

---

# 4. Evidence Collection

The following screenshots were collected during testing:

| Evidence | Location |
|---|---|
| Login page | Web-Security/Juice-Shop/Screenshots/login-page.png |
| Registration page | Web-Security/Juice-Shop/Screenshots/register-page.png |
| Successful login | Web-Security/Juice-Shop/Screenshots/login-success.png |
| Failed login | Web-Security/Juice-Shop/Screenshots/login-failed.png |

---

# 5. Observations

The application provides:

- User registration functionality
- Email and password authentication
- Authentication error messages for invalid credentials
- Session management after successful login

---

# 6. Security Considerations

Authentication mechanisms should:

- Enforce strong password requirements
- Protect against brute-force attacks
- Avoid revealing sensitive information in error messages
- Use secure session management
- Protect authentication requests using HTTPS

---

# 7. Lessons Learned

This assessment provided practical experience in:

- Testing authentication workflows
- Evaluating login functionality
- Documenting authentication behaviour
- Collecting assessment evidence
- Producing professional security documentation

---

# Conclusion

The authentication functionality of OWASP Juice Shop was successfully evaluated in a controlled laboratory environment. This assessment established a baseline for future security testing of authentication and authorization features.
