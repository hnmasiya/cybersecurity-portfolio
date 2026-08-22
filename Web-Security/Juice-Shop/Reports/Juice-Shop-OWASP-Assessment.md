# OWASP Juice Shop Security Assessment

## Application

OWASP Juice Shop

## Assessment Type

Web Application Penetration Testing

---

## Objective

Identify and document common OWASP Top 10 vulnerabilities.

---

# Tools Used

- OWASP Juice Shop
- Burp Suite Community
- Browser Developer Tools

---

## Findings

## Authentication Weaknesses

Risk:

High


Observation:

Testing identified weaknesses related to authentication controls.


Impact:

Possible unauthorized account access.

---

## SQL Injection

Risk:

High


Observation:

Application input validation weaknesses allowed SQL manipulation testing.


Impact:

Potential database exposure.


---

## Broken Access Control

Risk:

High


Observation:

Application authorization controls were tested.


Impact:

Unauthorized access to restricted resources.

---

## Recommendations

- Implement strong authentication controls
- Apply secure coding practices
- Validate all user input
- Perform regular security testing

---

# Conclusion

The assessment demonstrated practical understanding of OWASP Top 10 testing methodologies.
---

# Evidence

Screenshots:

- Authentication testing
- SQL Injection testing
- Access control testing

Example:

![Juice Shop Testing](../Screenshots/sql-injection-success.png)

---

# Testing Methodology

Testing followed:

- OWASP Top 10
- Manual verification
- Browser inspection
- Proxy analysis

## Skills & Tools

Document the actual security domains and tools used in this lab.

**Evidence status:** This section is limited to information supported by the existing Juice Shop laboratory documentation and screenshots. No additional technical detail is asserted without matching repository evidence.

## Architecture

Describe the actual laboratory architecture using only verified information.

**Evidence status:** This section is limited to information supported by the existing Juice Shop laboratory documentation and screenshots. No additional technical detail is asserted without matching repository evidence.

## Topology

Document the actual traffic/data flow between assessment host, target and monitoring components.

**Evidence status:** This section is limited to information supported by the existing Juice Shop laboratory documentation and screenshots. No additional technical detail is asserted without matching repository evidence.

## Execution

Document the actual steps performed during the exercise.

**Evidence status:** This section is limited to information supported by the existing Juice Shop laboratory documentation and screenshots. No additional technical detail is asserted without matching repository evidence.

## Walkthrough

Provide a chronological analyst walkthrough from preparation through evidence collection.

**Evidence status:** This section is limited to information supported by the existing Juice Shop laboratory documentation and screenshots. No additional technical detail is asserted without matching repository evidence.

## Attack Simulation

Document the controlled security activity actually performed.

**Evidence status:** This section is limited to information supported by the existing Juice Shop laboratory documentation and screenshots. No additional technical detail is asserted without matching repository evidence.

## Detection

Explain what observable event, response, alert or traffic indicated the security condition.

**Evidence status:** This section is limited to information supported by the existing Juice Shop laboratory documentation and screenshots. No additional technical detail is asserted without matching repository evidence.

## Triage

Explain initial validation, scope assessment and severity determination.

**Evidence status:** This section is limited to information supported by the existing Juice Shop laboratory documentation and screenshots. No additional technical detail is asserted without matching repository evidence.

## Investigation

Explain how evidence was correlated and analysed.

**Evidence status:** This section is limited to information supported by the existing Juice Shop laboratory documentation and screenshots. No additional technical detail is asserted without matching repository evidence.

## Root Cause

Identify the underlying weakness or configuration responsible.

**Evidence status:** This section is limited to information supported by the existing Juice Shop laboratory documentation and screenshots. No additional technical detail is asserted without matching repository evidence.

## MITRE ATT&CK

Map only techniques directly supported by the observed activity.

**Evidence status:** This section is limited to information supported by the existing Juice Shop laboratory documentation and screenshots. No additional technical detail is asserted without matching repository evidence.

## Remediation

Document corrective actions appropriate to the demonstrated weakness.

**Evidence status:** This section is limited to information supported by the existing Juice Shop laboratory documentation and screenshots. No additional technical detail is asserted without matching repository evidence.

## Lessons Learned

Summarise practical security and analyst lessons.

**Evidence status:** This section is limited to information supported by the existing Juice Shop laboratory documentation and screenshots. No additional technical detail is asserted without matching repository evidence.

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

<!-- FINAL-CORRECTION-JUICE-SHOP-2026 -->
## Impact

The identified OWASP Juice Shop weaknesses demonstrate how insecure application behaviour can affect confidentiality, integrity and authentication controls.

Potential impact depends on the specific vulnerability, attacker privileges, exposed functionality and application configuration. The laboratory results should therefore be treated as controlled security-testing evidence rather than evidence of a real-world compromise.

## Validation

Each identified issue should be retested using the original request, payload or workflow after remediation.

A vulnerability should only be marked as successfully remediated when the original behaviour has been reproduced as a negative test and the expected security control is observed to be functioning.
