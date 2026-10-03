# Wazuh Incident Response Investigation Report

## Lab Overview

**Project:** Security Information and Event Management (SIEM) Lab  
**Platform:** Wazuh SIEM  
**Category:** Incident Response Investigation  
**Environment:** Local Cybersecurity Home Lab  

---

## 1. Objective

The objective of this laboratory investigation was to use Wazuh SIEM capabilities to identify, triage and investigate security-relevant activity in a monitored environment. The investigation focused on reviewing alerts, examining available security telemetry, assessing the significance of the observed activity, documenting evidence and identifying appropriate response and remediation actions.

All technical conclusions are limited to evidence available in the laboratory environment and repository.

---

## 2. Investigation Process

The investigation followed a structured SOC workflow:

1. Review the generated Wazuh alert and its associated metadata.
2. Confirm the affected agent or monitored system.
3. Examine the available alert details and surrounding security telemetry.
4. Assess the activity for indicators of suspicious or malicious behavior.
5. Correlate available evidence with the observed security event.
6. Determine the likely significance and impact of the activity.
7. Document the evidence and recommended response actions.

Where exact event IDs, IP addresses, timestamps, rule IDs or other telemetry values are required, those values should be taken directly from the corresponding Wazuh alert or screenshot rather than inferred.

---

## 3. Detection

Wazuh detection was used to identify security-relevant activity from the monitored environment. The investigation process focused on reviewing alert metadata, timestamps, severity, affected hosts and available event information before determining whether further triage was required.

Detection conclusions are limited to information supported by the repository evidence and laboratory artifacts. Exact event IDs, source IP addresses, rule IDs and timestamps should only be reported where they can be verified directly from the Wazuh alert or supporting screenshot.

---

## 4. Findings

The investigation demonstrated that Wazuh can provide centralized visibility into security-relevant activity and support an analyst workflow from alert generation through investigation.

The repository evidence and laboratory artifacts support the presence of monitored agents, Wazuh alerts, dashboard visibility and custom detection activity. Exact technical findings should be interpreted from the associated alert data and screenshots.

---

## 5. Response Recommendations

Recommended actions:

- Investigate affected endpoints.
- Review user activity.
- Contain suspicious activity.
- Continue tuning detection rules to reduce false positives.
- Monitor agent health and ensure security telemetry is consistently available.
- Correlate Wazuh alerts with endpoint, authentication and network telemetry when supported by repository evidence.
- Document repeatable triage procedures for common alert types.
- Map significant detections to MITRE ATT&CK techniques when directly supported by laboratory evidence.
- Perform validation testing after detection-rule or configuration changes.

---

## 6. Evidence

No screenshots have been captured for this specific report yet. For investigation evidence that is captured, see
[SOC Alert Triage and IOC Enrichment](../../../Security-Automation/SOC-Alert-Triage/Reports/SOC-Alert-Triage-IOC-Enrichment.md),
which produces JSON evidence under `Evidence/`.

Agent status, dashboard visibility, alert details, and other live telemetry are not claimed as visual evidence unless a corresponding verifiable artifact is present in the repository.

---

## 7. Lessons Learned

This exercise reinforced the importance of validating alerts against underlying telemetry rather than treating every alert as automatically malicious. Effective SOC analysis requires understanding the alert context, identifying relevant evidence, distinguishing suspicious behavior from benign activity, and documenting conclusions in a reproducible manner.

It also demonstrated the value of centralized monitoring and custom detection rules for improving visibility into security events.

---

## Conclusion

The Wazuh incident response investigation demonstrated how SIEM platforms support detection, investigation, and response activities in security operations environments.
