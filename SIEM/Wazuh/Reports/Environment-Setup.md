# Wazuh SIEM Environment Setup Report

## Lab Overview

**Project:** Security Information and Event Management (SIEM) Lab  
**Platform:** Wazuh SIEM  
**Category:** Security Monitoring and Detection Engineering  
**Environment:** Local Cybersecurity Home Lab  
**Deployment:** Docker Container Environment  
**Operating System:** Zorin OS  
**Testing Tools:** Wazuh Dashboard, Docker, Linux Terminal

---

# 1. Introduction

Wazuh is an open-source Security Information and Event Management (SIEM) platform used for security monitoring, threat detection, log analysis, vulnerability detection, file integrity monitoring, and incident response.

This laboratory exercise focuses on deploying and validating a Wazuh monitoring environment within a local cybersecurity home lab.

---

# 2. Lab Objectives

The objectives of this lab were:

- Deploy a functional Wazuh SIEM environment
- Configure the Wazuh dashboard
- Verify Wazuh services
- Understand SIEM architecture components
- Prepare the environment for security monitoring exercises

---

# 3. Environment Details

| Component | Details |
|---|---|
| SIEM Platform | Wazuh |
| Deployment Method | Docker Compose |
| Host Operating System | Zorin OS |
| Container Platform | Docker |
| Dashboard | Wazuh Dashboard |
| Data Storage | Wazuh Indexer |
| Manager | Wazuh Manager |

---

# 4. Wazuh Architecture

The Wazuh platform consists of:

## Wazuh Manager

Responsible for:

- Receiving security events
- Applying detection rules
- Generating alerts
- Managing agents

## Wazuh Indexer

Responsible for:

- Storing security events
- Searching collected data
- Supporting dashboard queries

## Wazuh Dashboard

Provides:

- Security visualization
- Alert investigation
- Compliance monitoring
- Threat analysis

---

# 5. Deployment Validation

The deployment was validated by checking running Docker containers.

Validation activities:

- Confirmed Wazuh containers were running
- Accessed the Wazuh dashboard
- Verified communication between components
- Reviewed system status

---

# 6. Security Monitoring Capabilities

The Wazuh SIEM environment supports:

- Log collection
- Intrusion detection
- File integrity monitoring
- Vulnerability detection
- Security configuration assessment
- Threat intelligence integration
- Incident investigation

---

# 7. Evidence

---

# 8. Lessons Learned

This lab provided practical experience with:

- SIEM deployment
- Security monitoring architecture
- Log management concepts
- Alert investigation workflows
- Enterprise security monitoring technologies

---

# Conclusion

The Wazuh SIEM deployment successfully established a security monitoring platform within the cybersecurity home lab.

The environment provides a foundation for future exercises involving threat detection, log analysis, alert investigation, and incident response.
