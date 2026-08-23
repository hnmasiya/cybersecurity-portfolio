# Enterprise Security Audit: Active Directory & Kerberos Hygiene

> **Status: Methodology / Illustrative Scenario.** This report demonstrates
> how I write up an AD/Kerberos hygiene audit finding. It is not a claim
> of a live domain audit in this portfolio — no domain, event data, or
> scan output backs this specific scenario. The techniques referenced here
> (Kerberoasting, AS-REP roasting) *are* backed by real, tested, offline
> detection logic: see
> [`Active-Directory/Detection-Lab/`](../../Active-Directory/Detection-Lab/README.md)
> for the actual detection rules, synthetic event data, and pytest suite.

## Metadata
* **Domain:** corp.internal
* **Auditor:** Hazvinei Masiya
* **Date:** 2026-08-22

---

## Key Findings
* **Kerberoasting Risk:** Identified 3 service accounts with weak RC4 encryption enabled on Service Principal Names (SPNs).
* **AS-REP Roasting:** 2 user accounts found with 'Do not require Kerberos pre-authentication' enabled.
* **Remediation:** Forced AES-256 encryption across all domain controllers and disabled pre-auth exemptions.
