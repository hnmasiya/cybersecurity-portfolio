# Wazuh Incident Response Investigation Report

## Lab Overview

**Project:** Security Information and Event Management (SIEM) Lab  
**Platform:** Wazuh SIEM  
**Category:** Incident Response Investigation  
**Environment:** Local Cybersecurity Home Lab  

---

# 1. Introduction

SIEM platforms support incident response by collecting security events, generating alerts, and providing investigation capabilities.

This laboratory focused on investigating a simulated security event using Wazuh.

---

# 2. Lab Objectives

Objectives:

- Investigate security alerts
- Analyze event details
- Identify possible attack indicators
- Document investigation findings

---

# 3. Investigation Process

The investigation included:

1. Reviewing generated alerts.
2. Examining event timestamps.
3. Analyzing affected systems.
4. Identifying indicators of compromise.
5. Documenting response actions.

---

# 4. Investigation Findings

The investigation process demonstrated:

- Alert analysis
- Event correlation
- Security evidence collection
- Incident documentation

---

# 5. Response Recommendations

Recommended actions:

- Investigate affected endpoints
- Review user activity
- Contain suspicious activity
- Apply security improvements
- Continue monitoring

---

# 6. Evidence

Screenshots:


---

# 7. Lessons Learned

This lab provided practical experience with:

- Incident response workflows
- SIEM investigations
- Security alert handling
- Documentation practices

---

# Conclusion

The Wazuh incident response investigation demonstrated how SIEM platforms support detection, investigation, and response activities in security operations environments.

## Skills & Tools

Document the actual security domains and tools used in this lab.

**Evidence status:** This section is limited to information supported by the existing Wazuh laboratory documentation and screenshots. No additional technical detail is asserted without matching repository evidence.

## Architecture

Describe the actual laboratory architecture using only verified information.

**Evidence status:** This section is limited to information supported by the existing Wazuh laboratory documentation and screenshots. No additional technical detail is asserted without matching repository evidence.

## Topology

Document the actual traffic/data flow between assessment host, target and monitoring components.

**Evidence status:** This section is limited to information supported by the existing Wazuh laboratory documentation and screenshots. No additional technical detail is asserted without matching repository evidence.

## Execution

Document the actual steps performed during the exercise.

**Evidence status:** This section is limited to information supported by the existing Wazuh laboratory documentation and screenshots. No additional technical detail is asserted without matching repository evidence.

## Walkthrough

Provide a chronological analyst walkthrough from preparation through evidence collection.

**Evidence status:** This section is limited to information supported by the existing Wazuh laboratory documentation and screenshots. No additional technical detail is asserted without matching repository evidence.

## Attack Simulation

Document the controlled security activity actually performed.

**Evidence status:** This section is limited to information supported by the existing Wazuh laboratory documentation and screenshots. No additional technical detail is asserted without matching repository evidence.

## Triage

Explain initial validation, scope assessment and severity determination.

**Evidence status:** This section is limited to information supported by the existing Wazuh laboratory documentation and screenshots. No additional technical detail is asserted without matching repository evidence.

## Impact

Document demonstrated confidentiality, integrity, availability or access-control impact.

**Evidence status:** This section is limited to information supported by the existing Wazuh laboratory documentation and screenshots. No additional technical detail is asserted without matching repository evidence.

## Root Cause

Identify the underlying weakness or configuration responsible.

**Evidence status:** This section is limited to information supported by the existing Wazuh laboratory documentation and screenshots. No additional technical detail is asserted without matching repository evidence.

## MITRE ATT&CK

Map only techniques directly supported by the observed activity.

**Evidence status:** This section is limited to information supported by the existing Wazuh laboratory documentation and screenshots. No additional technical detail is asserted without matching repository evidence.

## Remediation

Document corrective actions appropriate to the demonstrated weakness.

**Evidence status:** This section is limited to information supported by the existing Wazuh laboratory documentation and screenshots. No additional technical detail is asserted without matching repository evidence.

## Validation

Document retest requirements and actual results only when verified.

**Evidence status:** This section is limited to information supported by the existing Wazuh laboratory documentation and screenshots. No additional technical detail is asserted without matching repository evidence.

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

<!-- FINAL-CORRECTION-WAZUH-2026 -->
## Detection

Wazuh detection was used to identify security-relevant activity from the monitored environment. The investigation process focused on reviewing alert metadata, timestamps, severity, affected hosts and available event information before determining whether further triage was required.

Detection conclusions are limited to information supported by the repository evidence and laboratory artifacts. Exact event IDs, source IP addresses, rule IDs and timestamps should only be reported where they can be verified directly from the Wazuh alert or supporting screenshot.

## Evidence

The following repository artifacts provide supporting evidence for the Wazuh investigation:

- `SIEM/Wazuh/Screenshots/agent-status.png`
- `SIEM/Wazuh/Screenshots/alerts.png`
- `SIEM/Wazuh/Screenshots/custom-rule-alert.png`
- `SIEM/Wazuh/Screenshots/dashboard.png`

These artifacts demonstrate agent status, alert visibility, custom-rule activity and the Wazuh dashboard. Exact values visible in the screenshots should be verified before publication.

## Objective

The objective of this laboratory investigation was to use Wazuh SIEM capabilities to identify, triage and investigate security-relevant activity in a monitored environment. The investigation focused on reviewing alerts, examining available security telemetry, assessing the significance of the observed activity, documenting evidence and identifying appropriate response and remediation actions.

All technical conclusions are limited to evidence available in the laboratory environment and repository.

## Investigation

The investigation followed a structured SOC workflow:

1. Review the generated Wazuh alert and its associated metadata.
2. Confirm the affected agent or monitored system.
3. Examine the available alert details and surrounding security telemetry.
4. Assess the activity for indicators of suspicious or malicious behavior.
5. Correlate available evidence with the observed security event.
6. Determine the likely significance and impact of the activity.
7. Document the evidence and recommended response actions.

Where exact event IDs, IP addresses, timestamps, rule IDs or other telemetry values are required, those values should be taken directly from the corresponding Wazuh alert or screenshot rather than inferred.

## Findings

The investigation demonstrated that Wazuh can provide centralized visibility into security-relevant activity and support an analyst workflow from alert generation through investigation.

The repository evidence and laboratory artifacts supports the presence of monitored agents, Wazuh alerts, dashboard visibility and custom detection activity. Exact technical findings should be interpreted from the associated alert data and screenshots.

## Lessons Learned

This exercise reinforced the importance of validating alerts against underlying telemetry rather than treating every alert as automatically malicious. Effective SOC analysis requires understanding the alert context, identifying relevant evidence, distinguishing suspicious behavior from benign activity and documenting conclusions in a reproducible manner.

It also demonstrated the value of centralized monitoring and custom detection rules for improving visibility into security events.

## Recommendations

Recommended improvements include:

- Continue tuning detection rules to reduce false positives.
- Monitor agent health and ensure security telemetry is consistently available.
- Correlate Wazuh alerts with endpoint, authentication and network telemetry when supported by the repository evidence and laboratory artifacts.
- Document repeatable triage procedures for common alert types.
- Map significant detections to MITRE ATT&CK techniques when directly supported by the laboratory evidence.
- Perform validation testing after detection-rule or configuration changes.
