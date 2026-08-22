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

Information disclosure vulnerabilities can expose:

- Hidden application paths
- Internal files
- Configuration information
- Sensitive resources
- Development-related information
- Application structure details

---

# 2. Testing Environment

| Component | Details |
|---|---|
| Application | OWASP Juice Shop |
| Vulnerability | Sensitive Data Exposure / Information Disclosure |
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
4. Capturing screenshots as evidence.
5. Documenting security impact.
6. Providing remediation recommendations.

---

# 4. Vulnerability Testing and Evidence Collection

## 4.1 robots.txt Information Disclosure

### Resource Tested


http://localhost:3000/robots.txt


### Observation

The robots.txt file was publicly accessible and revealed application paths that could assist attackers during reconnaissance activities.

Attackers may use information contained within robots.txt files to identify hidden directories and potential attack targets.

### Security Impact

Exposure of application paths may assist attackers in mapping the application structure and identifying additional areas for security testing.

### Evidence


Web-Security/Juice-Shop/Screenshots/robots-txt.png


---

## 4.2 Security.txt Information Disclosure

### Resource Tested


http://localhost:3000/.well-known/security.txt


### Observation

The security.txt file was publicly accessible and provided information related to the application's security contact process.

Although security.txt files are commonly used for responsible vulnerability disclosure, exposed information should be reviewed to ensure unnecessary details are not revealed.

### Security Impact

Publicly available application information may assist attackers during reconnaissance activities and provide additional knowledge about the application's security processes.

### Evidence


Web-Security/Juice-Shop/Screenshots/security-txt.png


---

## 4.3 Exposed File Resources

### Resource Tested


http://localhost:3000/ftp/


### Observation

The application exposed files through a publicly accessible directory.

This demonstrates insufficient access restrictions on sensitive resources and may allow unauthorized users to access files that should not be publicly available.

### Security Impact

Attackers may download exposed files and use the information obtained for further attacks.

Potential risks include:

- Disclosure of sensitive files
- Exposure of application information
- Improved attacker reconnaissance capability
- Increased attack surface

### Evidence


Web-Security/Juice-Shop/Screenshots/exposed-files.png


---

# 5. Impact Assessment

Successful exploitation of sensitive data exposure vulnerabilities may allow an attacker to:

- Perform application reconnaissance
- Identify hidden resources and directories
- Discover application structure
- Collect information useful for further attacks
- Access publicly exposed files
- Increase the effectiveness of future exploitation attempts

**Risk Rating: Medium**

---

# 6. Remediation Recommendations

Recommended security improvements:

- Remove unnecessary publicly accessible files
- Restrict access to sensitive directories
- Disable unnecessary directory listing
- Review web server configuration
- Apply proper authorization controls
- Avoid exposing internal application information
- Secure configuration files and resources
- Regularly review publicly accessible content
- Perform vulnerability assessments regularly
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
- Reviewing publicly accessible resources
- Understanding attacker information gathering techniques
- Collecting security evidence
- Documenting vulnerabilities professionally
- Writing vulnerability assessment reports

---

# Conclusion

The OWASP Juice Shop Sensitive Data Exposure assessment demonstrated how publicly accessible resources can reveal information that may assist attackers during reconnaissance and exploitation activities.

This controlled laboratory exercise provided hands-on experience in vulnerability identification, evidence collection, impact assessment, and security remediation recommendations.

The assessment improved practical understanding of web application security testing, information disclosure risks, and secure application configuration practices.
