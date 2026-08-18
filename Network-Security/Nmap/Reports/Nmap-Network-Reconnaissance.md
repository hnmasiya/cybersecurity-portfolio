# Nmap Network Reconnaissance Report

## Assessment Type

Network Discovery and Service Enumeration

## Tool

Nmap

---

# Objective

Identify available hosts, open ports, and exposed services within the authorised laboratory environment.

---

# Commands Used

Example:

nmap -sV -sC <target>

---

# Findings

## Host Discovery

Identified active hosts within the testing network.

---

## Service Enumeration

Collected information about:

- Open ports
- Running services
- Service versions

---

# Security Analysis

Exposed services increase attack surface.

Recommendations:

- Disable unnecessary services
- Patch outdated software
- Restrict network access

---

# Skills Demonstrated

- Network reconnaissance
- Port scanning
- Service identification
- Risk assessment
---

# Evidence

Scan Output:

Example:
nmap -sV -sC target


Captured information:

- Open ports
- Service versions
- Potential risks


Screenshot:

![Nmap Scan](../Screenshots/nmap-scan.png)

---

# Analyst Recommendation

Reduce attack surface by:

- Closing unused ports
- Updating exposed services
- Restricting access

## Skills & Tools

Document the actual security domains and tools used in this lab.

> **VERIFICATION REQUIRED:** Add exact technical details only when supported by the existing lab evidence.

## Architecture

Describe the actual laboratory architecture using only verified information.

> **VERIFICATION REQUIRED:** Add exact technical details only when supported by the existing lab evidence.

## Topology

Document the actual traffic/data flow between assessment host, target and monitoring components.

> **VERIFICATION REQUIRED:** Add exact technical details only when supported by the existing lab evidence.

## Execution

Document the actual steps performed during the exercise.

> **VERIFICATION REQUIRED:** Add exact technical details only when supported by the existing lab evidence.

## Walkthrough

Provide a chronological analyst walkthrough from preparation through evidence collection.

> **VERIFICATION REQUIRED:** Add exact technical details only when supported by the existing lab evidence.

## Attack Simulation

Document the controlled security activity actually performed.

> **VERIFICATION REQUIRED:** Add exact technical details only when supported by the existing lab evidence.

## Detection

Explain what observable event, response, alert or traffic indicated the security condition.

> **VERIFICATION REQUIRED:** Add exact technical details only when supported by the existing lab evidence.

## Triage

Explain initial validation, scope assessment and severity determination.

> **VERIFICATION REQUIRED:** Add exact technical details only when supported by the existing lab evidence.

## Investigation

Explain how evidence was correlated and analysed.

> **VERIFICATION REQUIRED:** Add exact technical details only when supported by the existing lab evidence.

## Impact

Document demonstrated confidentiality, integrity, availability or access-control impact.

> **VERIFICATION REQUIRED:** Add exact technical details only when supported by the existing lab evidence.

## Root Cause

Identify the underlying weakness or configuration responsible.

> **VERIFICATION REQUIRED:** Add exact technical details only when supported by the existing lab evidence.

## MITRE ATT&CK

Map only techniques directly supported by the observed activity.

> **VERIFICATION REQUIRED:** Add exact technical details only when supported by the existing lab evidence.

## Remediation

Document corrective actions appropriate to the demonstrated weakness.

> **VERIFICATION REQUIRED:** Add exact technical details only when supported by the existing lab evidence.

## Validation

Document retest requirements and actual results only when verified.

> **VERIFICATION REQUIRED:** Add exact technical details only when supported by the existing lab evidence.

## Lessons Learned

Summarise practical security and analyst lessons.

> **VERIFICATION REQUIRED:** Add exact technical details only when supported by the existing lab evidence.

## Evidence Verification

Before publication, verify all technical claims against the repository evidence:

- IP addresses
- Hostnames
- Ports
- Event IDs
- Alert levels
- Payloads
- Vulnerability identifiers
- Packet characteristics
- MITRE ATT&CK mappings
- Remediation results
- Validation/retest results

Unsupported details must not be presented as observed findings.


## SOC Documentation Upgrade

This draft was generated from the existing repository evidence. Existing technical content was preserved. Unsupported technical details are explicitly marked for verification.

<!-- FINAL-CORRECTION-NMAP-2026 -->
## Recommendations

Based on the reconnaissance results, recommended defensive actions include:

- Remove unnecessary exposed services.
- Restrict management services to trusted administrative networks.
- Apply host-based firewall rules where appropriate.
- Maintain an accurate network and service inventory.
- Investigate unexpected or unauthorized listening services.
- Correlate discovered services with vulnerability-management results.
- Repeat the scan after remediation to verify that the exposed attack surface has changed as expected.

Recommendations should be adjusted according to the actual services and ports observed by the scan evidence.
