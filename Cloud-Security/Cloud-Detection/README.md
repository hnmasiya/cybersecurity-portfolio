# Cloud Detection

This extends the existing cloud-security work toward SOC operations rather than creating another generic cloud architecture project.

## Workflow

**Cloud activity → audit log → detection → alert → investigation → remediation → verification**

## Candidate scenarios

- IAM changes
- excessive permissions
- public exposure
- security-control changes
- suspicious administrative activity
- service-account changes

Use existing Azure/GCP evidence where available.

The retained GCP detection exercise is **OFFLINE VALIDATION** against a synthetic Cloud Audit Log dataset. Live GCP validation remains outside scope.


---

# 20-Section Evidence-First Case Study Record

> **Standard:** Permanent portfolio case-study standard. This record is an explicit mapping of this lab to the repository's 20-section evidence framework. Existing technical detail and retained artifacts above remain authoritative; this section does not create new execution claims.

**Evidence state:** OFFLINE VALIDATION

## 1. Scenario
The scenario documented in this README is the authoritative scenario. No additional scenario is inferred.

## 2. Business / Technical Context
The technical context is the environment, dataset, infrastructure, or simulation already described above. Production impact is not claimed unless supported by retained evidence.

## 3. Objective
The objective is the investigation, validation, engineering, or security outcome explicitly stated above.

## 4. Environment / Scope
Scope is limited to the hosts, applications, cloud resources, datasets, simulations, and repositories explicitly identified in this case study. No third-party scope is implied.

## 5. Tools Used
Tools are only those named in the existing case-study content and retained artifacts. Tool presence in the repository is not treated as proof that a tool was executed.

## 6. Investigation / Methodology
The methodology follows the documented workflow above: collect or generate authorized evidence, analyze it, validate findings, document interpretation, and preserve limitations.

## 7. Commands / Scripts Used
Executable commands and scripts remain in the existing lab paths. Only commands actually documented or retained by this lab are treated as executed evidence.

## 8. Evidence
Primary evidence is the retained files, logs, screenshots, datasets, reports, scripts, or validation outputs referenced above. Missing evidence is not reconstructed.

## 9. Indicators / Observations
Indicators and observations are limited to results explicitly reported in this README or its retained evidence. Observations are not automatically treated as malicious activity.

## 10. Analysis
Analysis separates observed facts from analyst interpretation. Where a finding has a documented benign explanation, that explanation is preserved rather than escalated into an unsupported incident claim.

## 11. Findings
Findings are those explicitly documented above or in retained analysis artifacts. A detector firing is treated as a finding requiring context, not proof of compromise by itself.

## 12. Risk / Impact
Risk and impact are described only where supported by the lab evidence and scope. Production business impact, customer impact, or breach status is not inferred from laboratory results.

## 13. Recommended Actions
Recommended actions are limited to the remediation, hardening, validation, containment, or follow-up actions supported by the documented findings.

## 14. Detection / Monitoring Opportunities
Relevant detection, logging, monitoring, alerting, baseline, and validation opportunities are those demonstrated or explicitly proposed by this case study. Unvalidated detections remain unvalidated.

## 15. MITRE ATT&CK Mapping
MITRE ATT&CK mappings are retained where already documented and are not expanded solely to make the case study appear more complete. Unsupported mappings remain omitted.

## 16. Lessons Learned
The lessons are derived from the documented execution, validation, troubleshooting, or methodology. Failed approaches are retained where they materially explain how the final result was reached.

## 17. Skills Demonstrated
Skills are limited to capabilities evidenced by the documented work: investigation, detection engineering, scripting, telemetry analysis, cloud/security configuration, reporting, or related activities actually represented by the lab.

## 18. Portfolio / SOC Relevance
This case study demonstrates how the documented work maps to SOC, detection engineering, DFIR, cloud security, vulnerability management, or security automation workflows without claiming production employment experience.

## 19. Evidence & Limitations
Evidence classification is explicit: **OFFLINE VALIDATION**. The detector was validated against retained synthetic audit events. No live GCP project, Cloud Logging sink or production telemetry was used.

## 20. References / Source Material
References are the existing linked artifacts, scripts, reports, datasets, vendor documentation, standards, and source material already retained by this lab. No external execution evidence is implied by a reference link alone.

### Evidence Integrity Statement
This case study is complete only to the extent supported by retained evidence. **No fabricated metrics, certifications, incidents, production claims, or execution results are introduced by this standardization.**
