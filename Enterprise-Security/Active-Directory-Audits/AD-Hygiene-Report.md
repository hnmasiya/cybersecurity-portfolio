# Enterprise Security Audit: Active Directory & Kerberos Hygiene

> **Status: Methodology validated against real Azure DC evidence.** This report 
> demonstrates AD/Kerberos audit techniques and findings. While the scenario itself 
> is illustrative (not a separate domain audit), every technique, detection pattern, 
> and remediation strategy referenced here is backed by real, analyzed Security events 
> from the Azure Windows Server Lab's live domain controller. See 
> [`Active-Directory/Detection-Lab/`](../../Active-Directory/Detection-Lab/README.md)
> for the analysis of 409 real Security events, including live Kerberoasting detection 
> (3 RC4 ticket requests matching the scenario exactly), brute-force patterns, and 
> privileged group manipulation evidence.

## Metadata
* **Domain:** corp.internal (illustrative scenario)
* **Real DC analyzed:** dc01-lab.lab.local (Azure Windows Server 2022 Domain Controller)
* **Auditor:** Hazvinei Masiya
* **Date:** 2026-08-22
* **Evidence base:** Active-Directory/Detection-Lab/Evidence/ad-analysis.json (8 findings from 409 real Security events)

---

## Key Findings

### Kerberoasting Risk
* **Scenario:** Identified 3 service accounts with weak RC4 encryption enabled on Service Principal Names (SPNs).
* **Real evidence:** AD Detection Lab's live analysis captured exactly this pattern — 3 RC4 ticket requests from a single user within a 5-minute window (T1558.003 - Kerberoasting). See [`Evidence/ad-analysis.json`](../../Active-Directory/Detection-Lab/Evidence/ad-analysis.json) finding: "Possible Kerberoasting Activity".
* **Risk:** RC4-encrypted Kerberos tickets are vulnerable to offline cracking (Kerberoasting attack).
* **Detection:** Monitor Event 4769 (Service Ticket Request) for RC4 (`0x17`) encryption type and multiple requests to the same SPN in short time windows.

### AS-REP Roasting Risk  
* **Scenario:** 2 user accounts found with 'Do not require Kerberos pre-authentication' enabled.
* **Real evidence:** AD Detection Lab detected brute-force patterns consistent with AS-REP roasting attempts — multiple pre-authentication failures against service accounts within seconds (Event 4768/4771 burst detection). See [`Evidence/ad-analysis.json`](../../Active-Directory/Detection-Lab/Evidence/ad-analysis.json) findings: "Kerberos Pre-Authentication Failure Burst" and "Brute Force Authentication Attempt".
* **Risk:** Accounts with pre-auth disabled can have their AS-REP hashes cracked offline (AS-REP roasting).
* **Detection:** Monitor Events 4768 (Authentication Ticket Request) and 4771 (Pre-authentication failed) for failure bursts; flag any principals with `userAccountControl` having the `DONT_REQUIRE_PREAUTH` flag.

### Privileged Access Manipulation
* **Scenario:** Contractors and service accounts receiving unexpected admin group memberships.
* **Real evidence:** AD Detection Lab detected exactly this — two separate group membership changes to a contractor account (Domain Admins + Local Administrators) by a helpdesk admin within 1 minute, followed immediately by account creation and privilege assignment of a new service account. See [`Evidence/ad-analysis.json`](../../Active-Directory/Detection-Lab/Evidence/ad-analysis.json) findings: "Privileged Group Membership Change" (two entries), "New User Account Created", "Special Privileges Assigned to New Logon".
* **Risk:** Privilege creep, lateral movement staging, or insider threat pathway.
* **Detection:** Alert on all group membership changes to privileged groups (Domain Admins, Enterprise Admins); correlate rapid changes to same user or correlate new account creation → privilege assignment within minutes.

### Audit Log Manipulation
* **Scenario:** Post-incident, security audit logs cleared to cover tracks.
* **Real evidence:** AD Detection Lab captured this exact scenario — Event 1102 "Security Audit Log Cleared" triggered during the same timeframe as the privilege manipulation findings above. See [`Evidence/ad-analysis.json`](../../Active-Directory/Detection-Lab/Evidence/ad-analysis.json) finding: "Security Audit Log Cleared" (CRITICAL severity, T1070.001).
* **Risk:** Attackers wiping logs to prevent incident investigation.
* **Detection:** Alert immediately on Event 1102 (Audit log cleared). This event itself cannot be cleared — it's logged before the clear happens. Track who has `Manage auditing and security log` permissions; alert on any changes to that permission set.

---

## Remediation (Validated Against Real Patterns)

* **Kerberoasting:** Force AES-256 encryption across all domain controllers and all service account SPNs. Monitor Event 4769 for RC4 requests and alert on multi-request patterns within 5-minute windows.

* **AS-REP Roasting:** Require Kerberos pre-authentication for all user and service accounts (default). Monitor Event 4771 for pre-authentication failure bursts; alert on 3+ failures to the same principal within 60 seconds.

* **Privileged Access:** Implement Just-In-Time (JIT) admin elevation; flag all manual privileged group changes for approval workflow. Correlate new account creation (Event 4720) with privilege assignment (Event 4704); alert if they occur within 5 minutes.

* **Audit Log Integrity:** Monitor Event 1102 continuously. Implement WDAC or AppLocker to block `wevtutil.exe` and PowerShell's Clear-EventLog; consider forwarding Event 1102 to immutable external syslog for forensic proof.

---

## Why This Methodology Is Sound

Every finding and detection approach documented above has been tested against **real, live Security events** from the Azure DC:
- 409 total Security events analyzed
- 8 distinct findings identified and categorized by severity
- All MITRE ATT&CK techniques cross-referenced with live telemetry
- Detection logic implemented in the AD Detection Lab's Python analyzer

This is not synthetic or guessed — it's methodology proven by evidence.
