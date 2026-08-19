# SOC Incident Report: Wazuh SIEM Alert Triage & Investigation

## 📋 Executive Summary
* **Incident ID:** WR-2026-001
* **Severity:** High (Level 10+)
* **Detected By:** Wazuh Host-Based Intrusion Detection System (HIDS)
* **Status:** Resolved / Contained

## 🔍 Incident Discovery & Alert Details
An automated high-severity alert triggered on the centralized Wazuh Manager dashboard. The telemetry indicated an anomalous event pattern mapping directly to credential brute-forcing and unauthorized discovery attempts.

* **Target Host:** Ubuntu-Server-01 (Wazuh Agent ID: 004)
* **Triggered Rule ID:** 5712 (SSHD Brute Force Attempt)
* **Log Source:** `/var/log/auth.log`

## 🛠️ Evidence & Artifact Analysis
*(Note to Norman: Update the image paths below to point to your 5 screenshots!)*

### 1. Dashboard Alert Overview
*Figure 1: Initial alert visibility on the Wazuh indexer dashboard showcasing an elevated alert spike.*

### 2. Log Analysis & Attacker Footprint
```text
Feb 07 05:30:11 ubuntu-server sshd[2841]: Failed password for invalid user admin from 192.168.1.45 port 49210 ssh2
Feb 07 05:30:13 ubuntu-server sshd[2843]: Failed password for invalid user root from 192.168.1.45 port 49212 ssh2
```
*Figure 2: Raw syslog parsing showing rapid authentication failures from an internal subnet IP.*

## 🛡️ Containment & Mitigation Actions
As an IT Support Specialist acting in a SOC capacity, the following technical controls were executed on the Zorin workstation/lab environment:
1. **Network Isolation**: Applied a local `iptables` rule to drop all incoming traffic from the rogue source IP (`192.168.1.45`).
2. **Account Hardening**: Verified that the root SSH login capability was explicitly set to `PermitRootLogin no` inside `/etc/ssh/sshd_config`.
3. **Service Restart**: Cycled the SSH daemon to apply strict policy configurations.

## 🧠 Lessons Learned
* **Out-of-the-Box Noise**: The default Wazuh rule threshold required slight tuning to avoid alert fatigue during routine automated administrative tasks.
* **Proactive Defense**: Implementing `Fail2Ban` alongside Wazuh would automate the active response mechanism to drop attackers before manual intervention is needed.
