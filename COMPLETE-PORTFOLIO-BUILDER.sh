
#!/bin/bash

echo "Building Professional Cybersecurity Portfolio Documentation"

mkdir -p Professional-Portfolio/Projects
mkdir -p Professional-Portfolio/Reports
mkdir -p Evidence/SOC
mkdir -p Evidence/Web
mkdir -p Evidence/Network


cat > Professional-Portfolio/Projects/Wazuh-SIEM-Lab.md <<'DOC'

# Building an Open-Source SIEM Lab with Wazuh


# 🎯 Objective

This project demonstrates the deployment and operation of an open-source Security Information and Event Management (SIEM) platform using Wazuh.

The objective was to simulate enterprise security monitoring by collecting endpoint telemetry, analysing security events, detecting suspicious activity, and performing SOC-style investigations.


# 🛠️ Skills & Tools Leveraged

## Core Domains

- Security Monitoring
- Incident Response
- Log Analysis
- Threat Detection
- Detection Engineering
- Alert Investigation


## Tools Used

- Wazuh SIEM
- Linux Ubuntu
- Windows Endpoint Monitoring
- Docker
- Wireshark
- Syslog
- MITRE ATT&CK Framework


# 🏗️ Architectural Topology


             Analyst
                |
          Wazuh Dashboard
                |
        Wazuh Manager
          Docker Host
                |
    ----------------------
    |                    |

## Components

### Endpoint A

Windows Client

Purpose:

- Endpoint telemetry
- Security event collection
- Authentication monitoring


### Endpoint B

Linux Server

Purpose:

- Authentication logs
- System monitoring
- Service monitoring


### SIEM Core

Wazuh Manager deployed on Linux Docker host.


# 🚀 Execution & Walkthrough


# Phase 1: Deployment & Log Ingestion


Activities completed:

1. Installed Wazuh SIEM environment.
2. Configured dashboard access.
3. Connected monitored endpoints.
4. Verified telemetry ingestion.


# Phase 2: Attack Simulation & Threat Generation


Security events tested:

- Authentication failures
- Brute-force behaviour
- Suspicious activity generation


Examples:

- SSH failed login attempts
- Multiple authentication failures
- Endpoint security events


# Phase 3: Detection & Triage


SOC Investigation Process:


1. Alert received in Wazuh dashboard.

2. Analyst reviewed:

- Timestamp
- Source address
- Username
- Event severity
- Log source


3. Determined:

- False positive
- Security event
- Potential incident


# 📊 Evidence & Artifacts


Add screenshots:


- Wazuh Dashboard Alert
- Agent Status
- Detection Rule
- Investigation Timeline


Example:


![Wazuh Alert](../../Evidence/SOC/wazuh-alert.png)


# 🧠 Key Takeaways & Lessons Learned


Lessons learned:

- Importance of centralized logging
- SIEM alert tuning
- Reducing false positives
- Understanding attacker behaviour
- Improving detection capability


Future improvements:

- Add custom detection rules
- Integrate threat intelligence feeds
- Automate response actions

DOC



cat > Professional-Portfolio/Projects/Security-Assessment-Template.md <<'DOC'


# Security Assessment Project


# 🎯 Objective


Describe the security problem being investigated and why it matters to enterprise security teams.


# 🛠️ Skills & Tools Leveraged


Core Domains:

- Vulnerability Management
- Security Testing
- Risk Analysis


Tools:

- Nmap
- Wireshark
- Burp Suite
- OWASP Tools


# 🏗️ Architectural Topology


Describe:

- Target system
- Testing environment
- Security tools used


# 🚀 Execution & Walkthrough


## Phase 1: Preparation

Document:

- Environment setup
- Tools installed
- Scope


## Phase 2: Security Testing


Document:

- Tests performed
- Findings discovered
- Evidence collected


## Phase 3: Analysis


Document:

- Severity
- Business impact
- Recommendations


# 📊 Evidence & Artifacts


Add:

- Screenshots
- Logs
- Reports
- PCAP files


# 🧠 Key Takeaways & Lessons Learned


Document:

- Challenges faced
- Fixes applied
- Skills gained


DOC



echo "Documentation framework created"

