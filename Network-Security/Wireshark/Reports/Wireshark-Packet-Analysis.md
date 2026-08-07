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
2. **Network Segmentation:** Implement strict VLAN structures to prevent a compromised host from capturing adjacent broadcast domains or traffic pools.
3. **Deploy Network IDS (NIDS):** Configure tools like Zeek or Snort to automatically log alerts whenever cleartext credential fields traverse network borders.
