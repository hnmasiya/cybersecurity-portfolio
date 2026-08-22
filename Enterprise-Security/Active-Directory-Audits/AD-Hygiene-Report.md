# Enterprise Security Audit: Active Directory & Kerberos Hygiene

## Metadata
* **Domain:** corp.internal
* **Auditor:** Hazvinei Masiya
* **Date:** 2026-08-22

---

## Key Findings
* **Kerberoasting Risk:** Identified 3 service accounts with weak RC4 encryption enabled on Service Principal Names (SPNs).
* **AS-REP Roasting:** 2 user accounts found with 'Do not require Kerberos pre-authentication' enabled.
* **Remediation:** Forced AES-256 encryption across all domain controllers and disabled pre-auth exemptions.
