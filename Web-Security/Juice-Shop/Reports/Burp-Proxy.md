# OWASP Juice Shop - Burp Proxy Assessment

## Lab Overview

**Project:** Web Application Security Testing Lab  
**Application:** OWASP Juice Shop  
**Assessment:** Burp Suite Proxy Configuration  
**Category:** Web Application Security Testing  
**Testing Environment:** Local Cybersecurity Home Lab

---

# 1. Objective

The objective of this exercise was to configure Burp Suite Community Edition as an intercepting proxy and verify that HTTP requests between the browser and OWASP Juice Shop could be captured and analyzed.

---

# 2. Testing Environment

| Component | Details |
|---|---|
| Application | OWASP Juice Shop |
| Operating System | Zorin OS |
| Web Server | Docker Container |
| Browser | Google Chrome |
| Proxy Tool | Burp Suite Community Edition |

---

# 3. Methodology

The following steps were performed:

1. Started the OWASP Juice Shop Docker container.
2. Opened the application in a web browser.
3. Configured the browser to use Burp Suite as the HTTP proxy.
4. Captured HTTP requests using Burp Suite.
5. Verified successful interception of application traffic.

---

# 4. Evidence Collection

Screenshot:

Web-Security/Juice-Shop/Screenshots/burp-http-history.png

The screenshot confirms that Burp Suite successfully intercepted HTTP requests sent to the OWASP Juice Shop application.

---

# 5. Outcome

The assessment successfully demonstrated that Burp Suite was correctly configured and capable of intercepting, inspecting, and modifying HTTP traffic between the browser and the target application.

---

# Lessons Learned

This exercise provided practical experience in:

- Configuring Burp Suite
- Capturing HTTP requests
- Inspecting web application traffic
- Preparing for manual security testing

---

# Conclusion

The Burp Suite proxy configuration was successfully validated. This setup will be used throughout future OWASP Juice Shop penetration testing exercises.
