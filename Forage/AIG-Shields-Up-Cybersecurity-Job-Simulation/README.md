# AIG Shields Up: Cybersecurity Job Simulation — Forage

**Completed:** October 4, 2026  
**Platform:** Forage  
**Company:** AIG  
**Program:** Shields Up: Cybersecurity

## Scenario

A simulated Cyber Defense Unit exercise covering vulnerability and threat analysis, CISA advisory research, infrastructure identification, security remediation communication, and a controlled ransomware-recovery exercise.

## Business Context

The simulation required translating vulnerability intelligence into practical remediation guidance and applying incident-response thinking to a controlled ransomware scenario.

> **Evidence boundary:** This was a controlled Forage virtual job simulation. It was not employment at AIG and does not represent a real AIG security incident or production environment.

## Task 1 — Threat Intelligence and CISA Advisory Analysis

The exercise involved reviewing CISA security advisories, including material relating to **Log4j / CVE-2021-44228 (Log4Shell)** and ransomware.

The work focused on understanding reported vulnerabilities and translating threat intelligence into actionable security guidance.

[View Task 1](task-1/cisa-threat-analysis.md)

## Task 2 — Identify Affected Infrastructure

The supplied infrastructure inventory identified the:

- **Product Development Staging Environment**
- **Technology:** Log4j
- **Owning team:** Product Development
- **Owner listed in the simulation:** John Doe

The purpose was to connect vulnerability intelligence with the infrastructure that required remediation.

## Task 3 — Security Advisory Communication

Drafted an advisory email covering:

- The Log4Shell vulnerability.
- The risk of remote code execution.
- Verification of affected Log4j versions.
- Patching/remediation.
- Checking applications and bundled dependencies.
- Relevant mitigation measures.
- Log review for suspicious activity.
- Confirmation of remediation.

[View Task 3](task-2/remediation-advisory.md)

## Task 4 — Controlled Ransomware Recovery Exercise

The simulation provided an encrypted training archive and a controlled password-recovery exercise.

A Python `zipfile`-based brute-force script was used against the supplied training archive with the provided `rockyou.txt` wordlist.

The simulated exercise recovered the archive password:

**`SPONGEBOB`**

This was performed only within the Forage training environment.

[View Task 4](task-3/controlled-ransomware-recovery.md)

## Evidence / Findings

The simulation demonstrated the relationship between:

1. Vulnerability intelligence.
2. Asset identification.
3. Remediation communication.
4. Incident-response decision making.
5. Controlled technical recovery.

The infrastructure inventory was used to identify where Log4j-related remediation needed to be directed rather than treating vulnerability intelligence as an abstract technical issue.

## Analysis

**Threat intelligence → affected asset → responsible team → remediation guidance → validation**

The ransomware exercise added a practical recovery dimension by demonstrating how technical analysis can support recovery without simply assuming that paying a ransom is the preferred response.

## Recommended Actions

For an equivalent real-world vulnerability-response process:

- Identify all applications and services using the affected component.
- Verify exact dependency and version information.
- Prioritize internet-facing and business-critical systems.
- Patch or apply the appropriate vendor mitigation.
- Review bundled and transitive dependencies.
- Review relevant logs for exploitation indicators.
- Validate remediation after changes.
- Document ownership and remediation status.
- Maintain incident-response and recovery readiness for ransomware scenarios.

These are general response recommendations derived from the simulation context, not actions performed against AIG systems.

## Skills Demonstrated

- Vulnerability Research
- CISA Advisory Analysis
- Threat Analysis
- Risk Assessment
- Security Advisory Writing
- Incident Response
- Python
- File/Archive Analysis
- Ransomware Response
- Cybersecurity Communication
- Remediation Planning
- Technical-to-Business Translation

## Lessons Learned

- Threat intelligence becomes useful when mapped to specific assets and owners.
- Vulnerability response requires both technical verification and clear communication.
- Security advisories should provide actionable remediation steps rather than only describing a vulnerability.
- Incident-response exercises benefit from controlled technical validation.
- Recovery planning should be considered alongside prevention and containment.

## Portfolio Relevance

This simulation strengthens the portfolio's vulnerability-management, incident-response, Python automation and security-communication narrative.

It complements the portfolio's VAPT, Wazuh/SIEM, detection engineering, DFIR, cloud security and automation work.

## Official Simulation

[View AIG Shields Up: Cybersecurity on Forage](https://www.theforage.com/simulations/aig/cybersecurity-ku1i)

## Evidence Scope

This repository documents simulated learning activities completed through Forage. It does not claim employment, production access, or a real-world AIG engagement.
