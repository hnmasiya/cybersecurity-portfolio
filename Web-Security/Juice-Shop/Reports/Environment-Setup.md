# OWASP Juice Shop Environment Setup Report

## Lab Overview

**Project:** Modern Web Application Security Testing  
**Application:** OWASP Juice Shop  
**Category:** Web Application Security  
**Environment:** Local Cybersecurity Home Lab

---

# 1. Purpose

The purpose of this lab is to deploy OWASP Juice Shop as a modern vulnerable web application for practicing web application penetration testing techniques against realistic security flaws.

---

# 2. Lab Environment

| Component | Details |
|---|---|
| Operating System | Zorin OS |
| Application | OWASP Juice Shop |
| Deployment | Docker Container |
| Docker Image | bkimminich/juice-shop:latest |
| Web Browser | Firefox |
| Access URL | http://localhost:3000 |
| Security Testing Tools | Burp Suite Community Edition, Browser Developer Tools |

---

# 3. Deployment

The application was deployed locally using Docker.

Command used:

```bash
docker run -d --name juice-shop -p 3000:3000 bkimminich/juice-shop
```

The application started successfully and was accessible through the local web browser.

---

# 4. Service Verification

The Docker container was verified using:

```bash
docker ps
```

The output confirmed that the Juice Shop container was running and listening on TCP port 3000.

---

# 5. Access Verification

The application was successfully accessed using:

```text
http://localhost:3000
```

The homepage loaded successfully without errors.

---

# 6. Evidence Collection

The following evidence was collected:

| Evidence | Location |
|---|---|
| Juice Shop Homepage | Web-Security/Juice-Shop/Screenshots/juice-shop-home.png |

---

# 7. Lessons Learned

This exercise provided practical experience in:

- Deploying vulnerable applications with Docker
- Verifying containerized services
- Preparing a modern web application security lab
- Organizing professional penetration testing documentation

---

# Conclusion

OWASP Juice Shop was successfully deployed in the local cybersecurity laboratory. The application is ready for modern web application security testing, including authentication testing, API security assessments, broken access control testing, injection attacks, and client-side vulnerability analysis.
