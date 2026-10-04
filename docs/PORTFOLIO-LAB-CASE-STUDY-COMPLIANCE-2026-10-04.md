# Portfolio Lab Case-Study Compliance — 2026-10-04

## Standard

Every primary cybersecurity lab/case-study README uses the permanent 20-section evidence-first record:

1. Scenario
2. Business / Technical Context
3. Objective
4. Environment / Scope
5. Tools Used
6. Investigation / Methodology
7. Commands / Scripts Used
8. Evidence
9. Indicators / Observations
10. Analysis
11. Findings
12. Risk / Impact
13. Recommended Actions
14. Detection / Monitoring Opportunities
15. MITRE ATT&CK Mapping
16. Lessons Learned
17. Skills Demonstrated
18. Portfolio / SOC Relevance
19. Evidence & Limitations
20. References / Source Material

## Evidence states

- LIVE / REAL LAB
- CONTROLLED / SYNTHETIC
- OFFLINE VALIDATION
- ARCHITECTURE / METHODOLOGY
- PENDING VALIDATION
- VIRTUAL EXPERIENCE

The standardization does not convert one evidence state into another.

## Standardized primary case studies

- Active Directory Detection Lab
- SOC Automation
- Azure Windows Server Security Lab
- Azure Windows/Sysmon supporting lab
- Cloud Detection
- GCP Secure Landing Zone
- GCP Project Security
- Unified Cloud Detection & Response
- Container Configuration Security Audit
- Windows/Sysmon Endpoint Detection
- Executive Security Reporting
- Incident Response
- Linux Host Hardening
- Network PCAP Analysis
- Attack Simulation & Detection Engineering
- Splunk Labs 01–06
- Wazuh Detection Engineering
- SOC Detection Validation
- SOC Detection-as-Code
- SOC Detection-as-Code / Sigma
- SOC Detection-as-Code / Tests
- SOC Endpoint Detection
- SOC Flagship Investigation
- Microsoft Sentinel/KQL
- Microsoft Sentinel/KQL Detection Rules
- SOC Phishing Investigation
- Threat Hunting Detection Validation
- Threat Intelligence / IOC Investigation
- DVWA Web Security
- Remaining Phase 2 Network Investigation
- Remaining Phase 3 Web Security
- Phase 2 Linux Process Investigation

The four Forage simulations were already standardized as virtual-experience case studies before this lab-standardization pass.

## Navigation-only pages

Repository overview/index READMEs are intentionally not treated as individual labs. They provide navigation and portfolio context; they are not counted as evidence-bearing case studies.

## Evidence integrity

This compliance pass adds structure and explicit evidence-state mapping. It does not invent metrics, incidents, production claims, certifications, execution results, or missing evidence. Where work was not performed, the existing limitation remains authoritative.

## Completion gate

A lab is considered presentation-standard complete when its README contains the 20-section record, its evidence state is explicit, supporting artifacts remain linked, and its content can pass the repository's existing quality/security checks.

## Required Git workflow

Changes are made on a dedicated branch and must pass the repository's required checks before a squash merge to protected `main`. No direct push, force-push, reset, clean, or ruleset bypass is part of this process.
