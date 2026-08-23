# Application Security Assessment: SAST & SCA Pipeline Review

## Metadata
* **Project:** Microservices-Auth-API
* **Analyst:** Hazvinei Masiya
* **Date:** 2026-08-22

---

## 1. Executive Summary
Automated SAST and Software Composition Analysis (SCA) integrated into the CI/CD pipeline identified high-severity vulnerable dependencies and insecure cryptographic hardcoding.

### Critical Findings
* **CVE-2026-1042:** Log4j remote code execution vulnerability present in legacy logging wrapper package version 2.14.1.
* **Remediation:** Upgraded logging dependency to version 2.17.1 immediately via dependency manifest update.
