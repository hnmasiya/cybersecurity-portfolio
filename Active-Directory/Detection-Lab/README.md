# Active Directory Security Event Detection Lab

> **Evidence classification: Real telemetry + synthetic validation**

This lab analyzes Windows Security events for common identity and privilege-related security signals. It uses both controlled synthetic records and real telemetry exported from the deployed Azure Domain Controller.

## Detection Coverage

- Repeated failed authentication — Event ID `4625`
- Kerberos pre-authentication failure burst — `4771`
- Possible Kerberoasting indicators — `4769`
- Privileged group membership changes — `4728`, `4732`, `4756`
- New user account creation — `4720`
- Special privileges assigned to a new logon — `4672`
- Security audit log cleared — `1102`

Each analytic is mapped to relevant MITRE ATT&CK context in the supporting analysis.

## Validation

Synthetic data:

```bash
python3 Scripts/ad_security_event_analyzer.py --input Data/synthetic-ad-events.json --output Evidence/ad-analysis.json
```

Real telemetry:

```bash
python3 Scripts/ad_security_event_analyzer.py --input ../../Cloud-Security/Azure-Windows-Server-Lab/Evidence/raw-security-events.json --output ../../Cloud-Security/Azure-Windows-Server-Lab/Evidence/real-ad-analysis.json
```

The real capture contains **409 Windows Security events and 392 findings**. Those findings are deliberately retained and investigated rather than presented as proof of compromise.

## Real-Data Triage

The documented results include:

- 375 medium findings dominated by `SYSTEM`, machine-account and normal service/interactive activity.
- 16 high findings associated largely with the AD DS forest-promotion process and resulting group changes.
- 1 critical audit-log-cleared finding associated with lab configuration/promotion activity rather than a confirmed attacker action.

This demonstrates an important SOC skill: **detection output is an investigation starting point, not a verdict**.

## Evidence

- `Data/synthetic-ad-events.json` — controlled test input
- `Evidence/ad-analysis.json` — synthetic analysis
- Azure lab `Evidence/raw-security-events.json` — real Windows Security telemetry
- Azure lab `Evidence/real-ad-analysis.json` — real-data analysis
- `Scripts/ad_security_event_analyzer.py` — detection/analysis logic

## Analyst Workflow

**Event → analytic match → account/host context → related activity → benign explanation or escalation → documented finding**

## Limitations

The real dataset is from a controlled personal lab and is not representative of enterprise volume or attacker diversity. Findings are therefore suitable as portfolio evidence of detection analysis and triage methodology, not as proof of production incident-response experience.


---

# 20-Section Evidence-First Case Study Record

> **Standard:** Permanent portfolio case-study standard. This record is an explicit mapping of this lab to the repository's 20-section evidence framework. Existing technical detail and retained artifacts above remain authoritative; this section does not create new execution claims.

**Evidence state:** LIVE / REAL LAB

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
Evidence classification is explicit: **LIVE / REAL LAB**. Synthetic, offline, architectural, pending, or virtual evidence must not be represented as live production experience. Dataset size, environmental constraints, missing telemetry, and unperformed steps remain limitations.

## 20. References / Source Material
References are the existing linked artifacts, scripts, reports, datasets, vendor documentation, standards, and source material already retained by this lab. No external execution evidence is implied by a reference link alone.

### Evidence Integrity Statement
This case study is complete only to the extent supported by retained evidence. **No fabricated metrics, certifications, incidents, production claims, or execution results are introduced by this standardization.**
