# Application Security Assessment: SAST & SCA Pipeline Review

> **Status: Methodology / Illustrative Scenario.** This report demonstrates
> how I structure and write up a SAST/SCA finding, using a representative
> vulnerability class (a vulnerable logging dependency). It is not a claim
> of a finding against a live system in this portfolio — no pipeline
> config, scan output, or dependency manifest backs this specific scenario.
> For evidence-backed detection work, see `Security-Automation/` and
> `tests/`, where the analysis logic is real, tested, and runnable.

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
