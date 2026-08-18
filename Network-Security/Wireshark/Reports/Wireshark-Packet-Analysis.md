# Technical Report: Network Traffic Analysis & Packet Carving with Wireshark

## 📋 Executive Summary
* **Lab Objective:** Analyze packet capture (pcap) files to detect unencrypted protocols, reconstruct protocol streams, and extract potentially malicious files or exposed credentials.
* **Analyzed Protocols:** HTTP, FTP, DNS, TCP
* **Tool Matrix:** Wireshark, TShark, NetworkMiner

## 🔍 Investigation Walkthrough & Logic

### 1. Identifying Unencrypted Text & Cleartext Credentials
Enterprise environments should strictly forbid unencrypted protocols. In this phase of the lab, traffic was filtered to isolate cleartext transmission anomalies.
* **Wireshark Filter Used:** `http.request.method == "POST" || ftp`
* **Finding:** Captured cleartext login sequences transmitting corporate infrastructure parameters over unencrypted channels.

### 2. Follow TCP Stream (Reconstructing the Conversation)
By right-clicking a suspicious packet and isolating the specific TCP stream, the full payload interaction between the attacker machine and the host server was reconstructed.
* **Stream Details:** Analyzed a multi-stage request sequence tracking exactly what commands were sent to the server backend.

## 📊 Telemetry Evidence & Artifacts
*(Note to Norman: Update the image paths below to point to your Wireshark network captures!)*

### Traffic Volume and Protocol Breakdown
![Wireshark Hierarchy Capture](../../Screenshots/screenshot1.png)
*Figure 1: Protocol hierarchy window showcasing an unexpected spike in cleartext application layer telemetry.*

### Exposed Credentials Captured In Transit
```text
[Stream Data Isolate]
USER: anonymous
PASS: guest@enterprise.local
SYST
```
![Wireshark Credentials Reveal](../../Screenshots/screenshot1.png)
*Figure 2: Isolating cleartext credentials directly from network traffic payloads.*

## 🛡️ Remediation & Security Controls
To defend enterprise architecture against passive network sniffing and credential harvesting:
1. **Enforce Encryption Everywhere:** Mandate the use of HTTPS (TLS 1.3), SFTP, and SSH, deprecating all cleartext alternatives across internal subnets.
2. **Network Segmentation:** Implement strict VLAN structures to prevent a host under investigation from capturing adjacent broadcast domains or traffic pools.
3. **Deploy Network IDS (NIDS):** Configure tools like Zeek or Snort to automatically log alerts whenever cleartext credential fields traverse network borders.

## Skills & Tools

Document the actual security domains and tools used in this lab.

> **VERIFICATION REQUIRED:** Add exact technical details only when supported by the existing lab evidence.

## Topology

Document the actual traffic/data flow between assessment host, target and monitoring components.

> **VERIFICATION REQUIRED:** Add exact technical details only when supported by the existing lab evidence.

## Execution

Document the actual steps performed during the exercise.

> **VERIFICATION REQUIRED:** Add exact technical details only when supported by the existing lab evidence.

## Attack Simulation

Document the controlled security activity actually performed.

> **VERIFICATION REQUIRED:** Add exact technical details only when supported by the existing lab evidence.

## Detection

Explain what observable event, response, alert or traffic indicated the security condition.

> **VERIFICATION REQUIRED:** Add exact technical details only when supported by the existing lab evidence.

## Triage

Explain initial validation, scope assessment and severity determination.

> **VERIFICATION REQUIRED:** Add exact technical details only when supported by the existing lab evidence.

## Impact

Document demonstrated confidentiality, integrity, availability or access-control impact.

> **VERIFICATION REQUIRED:** Add exact technical details only when supported by the existing lab evidence.

## Root Cause

Identify the underlying weakness or configuration responsible.

> **VERIFICATION REQUIRED:** Add exact technical details only when supported by the existing lab evidence.

## MITRE ATT&CK

Map only techniques directly supported by the observed activity.

> **VERIFICATION REQUIRED:** Add exact technical details only when supported by the existing lab evidence.

## Validation

Document retest requirements and actual results only when verified.

> **VERIFICATION REQUIRED:** Add exact technical details only when supported by the existing lab evidence.

## Lessons Learned

Summarise practical security and analyst lessons.

> **VERIFICATION REQUIRED:** Add exact technical details only when supported by the existing lab evidence.

## Recommendations

Provide actionable controls and monitoring improvements.

> **VERIFICATION REQUIRED:** Add exact technical details only when supported by the existing lab evidence.

## Evidence Verification

Before publication, verify all technical claims against the repository evidence:

- IP addresses
- Hostnames
- Ports
- Event IDs
- Alert levels
- Payloads
- Vulnerability identifiers
- Packet characteristics
- MITRE ATT&CK mappings
- Remediation results
- Validation/retest results

Unsupported details must not be presented as observed findings.


## SOC Documentation Upgrade

This draft was generated from the existing repository evidence. Existing technical content was preserved. Unsupported technical details are explicitly marked for verification.

<!-- FINAL-CORRECTION-WIRESHARK-2026 -->
## Objective

The objective of this laboratory exercise was to analyse captured network traffic using Wireshark, identify relevant protocols and examine packet-level indicators that could support a security investigation.

The exercise demonstrates network visibility and packet-analysis techniques applicable to SOC monitoring and incident investigation.

## Architecture

The analysis was performed against a controlled laboratory packet capture. Traffic between participating hosts was examined through Wireshark to identify communication patterns, protocols, endpoints and potentially suspicious activity.

## Findings

Findings are based on information observable within the packet capture. Relevant observations may include source and destination addresses, ports, protocols, packet timing, TCP behaviour and application-layer information when supported by the repository evidence and laboratory artifacts.

No conclusion should be treated as proof of compromise unless supported by additional host, application or security telemetry.

## Walkthrough

The packet-analysis workflow consisted of examining the captured traffic, applying appropriate protocol or traffic filters, identifying relevant packets and reviewing packet-level fields to understand the observed communication.

The analysis focused on identifying useful security indicators such as source and destination systems, protocols, ports, connection behavior and other observable characteristics contained in the capture.

Only values directly observable in the packet capture should be treated as observed findings.

## Investigation

The investigation involved reviewing packet metadata and communication patterns to determine whether the observed traffic contained characteristics relevant to security monitoring.

The analyst should examine:

- Source and destination addresses
- Source and destination ports
- Protocols
- Connection establishment and termination
- Request and response behavior
- Repeated or unusual communication
- Potential indicators of reconnaissance or suspicious activity

Any conclusion regarding malicious behavior should be supported by the actual packet-level evidence.

## Remediation

Potential remediation depends on the traffic identified during analysis. Recommended actions may include restricting unnecessary services, filtering unwanted traffic, improving network segmentation, monitoring exposed services and investigating suspicious endpoints.

Where suspicious communication is identified, the associated host should be investigated using additional endpoint, authentication or SIEM telemetry before containment or remediation decisions are made.
