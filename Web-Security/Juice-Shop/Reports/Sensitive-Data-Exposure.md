# OWASP Juice Shop Sensitive Data Exposure Assessment Report

## Lab Overview

**Project:** Web Application Security Testing Lab  
**Application:** OWASP Juice Shop  
**Vulnerability:** Sensitive Data Exposure / Information Disclosure  
**Category:** Web Application Security Testing  
**Testing Environment:** Local Cybersecurity Home Lab  
**Testing Tools:** Browser, Burp Suite Community Edition  

---

# 1. Vulnerability Description

Sensitive Data Exposure occurs when an application unintentionally reveals information that should not be publicly accessible.

Exposed files, directories, application metadata, or configuration information may allow attackers to gather intelligence about the application and prepare further attacks.

---

# 2. Testing Environment

| Component | Details |
|---|---|
| Application | OWASP Juice Shop |
| Vulnerability | Sensitive Data Exposure |
| Deployment | Docker Container |
| Operating System | Zorin OS |
| Web Server | Node.js Application Server |
| Testing Tools | Browser, Burp Suite Community Edition |

---

# 3. Testing Methodology

The assessment was performed against the OWASP Juice Shop application running in a local Docker environment.

Testing activities included:

1. Accessing the Juice Shop application.
2. Reviewing publicly accessible resources.
3. Testing common information disclosure locations.
4. Capturing evidence screenshots.
5. Documenting security impact and remediation recommendations.

---

# 4. Vulnerability Testing and Evidence Collection

## 4.1 robots.txt Information Disclosure

**Resource Tested:**

**Observation:**

The robots.txt file was publicly accessible and revealed application paths that could assist attackers during reconnaissance activities.

Attackers may use information from robots.txt files to identify hidden directories and potential attack targets.

**Evidence:**

---

## 4.2 Security.txt Information Disclosure

**Resource Tested:**

**Observation:**

The security.txt file was accessible and provided publicly available information about the application security contact process.

While security.txt files are commonly used for responsible disclosure, unnecessary information exposure should be reviewed.

**Evidence:**

**Observation:**

The application exposed files through a publicly accessible directory.

This demonstrates insufficient access restrictions on sensitive resources and could allow attackers to download files that should not be publicly available.

**Evidence:**

---

# 5. Impact Assessment

Successful exploitation of sensitive data exposure vulnerabilities may allow an attacker to:

- Perform application reconnaissance
- Identify hidden resources and directories
- Discover application structure
- Collect information useful for further attacks
- Increase the effectiveness of exploitation attempts
- Access files that should not be publicly available

**Risk Rating: Medium**

---

# 6. Remediation Recommendations

Recommended security improvements:

- Remove unnecessary publicly accessible files
- Restrict access to sensitive directories
- Review web server configuration
- Apply proper authorization controls
- Avoid exposing internal application information
- Disable directory listing where unnecessary
- Perform regular vulnerability assessments
- Conduct security reviews before deployment

---

# 7. Evidence Files

| Evidence | Location |
|---|---|
| robots.txt disclosure | Web-Security/Juice-Shop/Screenshots/robots-txt.png |
| Security.txt review | Web-Security/Juice-Shop/Screenshots/security-txt.png |
| Exposed files | Web-Security/Juice-Shop/Screenshots/exposed-files.png |

---

# 8. Lessons Learned

This lab provided practical experience in:

- Identifying information disclosure vulnerabilities
- Performing web application reconnaissance
- Reviewing exposed application resources
- Understanding attacker information gathering techniques
- Collecting security evidence
- Writing professional vulnerability assessment reports

---

# Conclusion

The OWASP Juice Shop Sensitive Data Exposure assessment demonstrated how publicly accessible resources can reveal information that may assist attackers during reconnaissance and exploitation activities.

This controlled laboratory exercise provided hands-on experience in vulnerability identification, evidence collection, impact assessment, and security remediation recommendations.
