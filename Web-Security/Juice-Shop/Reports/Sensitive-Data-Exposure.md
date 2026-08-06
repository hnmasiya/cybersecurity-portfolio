# OWASP Juice Shop Sensitive Data Exposure Assessment Report

## Lab Overview

**Project:** Web Application Security Testing Lab  
**Application:** OWASP Juice Shop  
**Vulnerability:** Sensitive Data Exposure / Information Disclosure  
**Testing Tool:** Browser and Burp Suite Community Edition  
**Environment:** Local Cybersecurity Home Lab  

---

# 1. Vulnerability Description

Sensitive Data Exposure occurs when an application unintentionally exposes confidential information through publicly accessible files, directories, APIs, or application resources.

Attackers may use exposed information to identify weaknesses or gather intelligence about the application.

---

# 2. Testing Methodology

Testing steps:

1. Accessed Juice Shop application.
2. Tested common sensitive file locations.
3. Reviewed exposed application resources.
4. Documented information disclosure findings.
5. Captured evidence screenshots.

---

# 3. Testing Performed

The following locations were tested:

---

# 4. Findings

The application exposed information that could assist attackers during reconnaissance.

Examples of exposed information include:

- Application structure details
- Public files
- Configuration information
- Internal resource references

---

# 5. Impact Assessment

Information disclosure may allow attackers to:

- Perform better reconnaissance
- Identify application technologies
- Discover sensitive resources
- Plan further attacks

Risk Rating:

Medium

---

# 6. Remediation Recommendations

Recommended improvements:

- Remove unnecessary exposed files
- Restrict access to sensitive directories
- Review web server configuration
- Avoid exposing application metadata
- Perform regular security assessments

---

# 7. Evidence Files

| Evidence | Location |
|---|---|
| robots.txt disclosure | Screenshots/robots-txt.png |
| Security.txt disclosure | Screenshots/security-txt.png |
| Exposed files | Screenshots/exposed-files.png |

---

# Conclusion

This assessment demonstrated how publicly accessible resources can reveal information useful to attackers.

The exercise provided practical experience in reconnaissance, information disclosure analysis, and security documentation.

