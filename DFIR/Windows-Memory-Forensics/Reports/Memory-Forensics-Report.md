# Incident Investigation Report: Windows Memory Forensics (LockBit Variant Triage)

## Metadata
* **Case ID:** IR-2026-0822-04
* **Analyst:** Hazvinei Masiya
* **Host Affected:** WORKSTATION-04
* **Classification:** Ransomware Deployment / Process Injection
* **Date:** 2026-08-22

---

## 1. Executive Summary
On August 22, 2026, the SOC escalated an alert originating from WORKSTATION-04. Behavioral telemetry indicated anomalous process spawning and shadow copy deletion commands. Volatility 3 memory forensics were utilized to inspect volatile state artifacts from a physical memory dump (memdump.raw), confirming a LockBit ransomware variant execution chain via DLL injection and hollowed processes.

---

## 2. Technical Findings & Volatility Analysis

### Process Tree Analysis (windows.pstree)
* Identified parent process cmd.exe spawning a base64-encoded PowerShell execution string.
* Child process execution of vssadmin.exe delete shadows /all /quiet identified.

### Code Injection & Malfind (windows.malfind)
* **PID 4212 (powershell.exe)** exhibited malicious memory flags and MZ headers at offset 0x01f80000.

### Network Artifacts (windows.netscan)
* Active outbound TLS connection established from PID 4212 to external infrastructure.
