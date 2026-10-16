# Detection as Code

This area documents the portfolio's detection engineering work in a repeatable format.

## Current workflow

**Detection concept → detection logic → Wazuh implementation → test event → expected result → actual result → tuning**

## Each detection should contain

- Name
- Purpose
- Data source
- Event ID/log source
- Detection logic
- Severity
- ATT&CK mapping
- False-positive considerations
- Validation status
- Tuning notes

Do not claim Sigma compatibility, conversion or successful testing unless demonstrated by repository evidence.

---

# 20-Section Evidence-First Case Study Record

> **Standard:** Permanent portfolio case-study standard. This mapping preserves the existing content and makes the evidence state explicit without inventing missing execution evidence.

**Evidence state:** OFFLINE VALIDATION

## 1. Scenario
Use only the scenario already documented above; no new incident or attacker activity is inferred.
## 2. Business / Technical Context
The existing README and retained artifacts define the technical and training context. Production business impact is not inferred.
## 3. Objective
The documented objective is authoritative and is not expanded beyond retained evidence.
## 4. Environment / Scope
Scope is limited to explicitly documented systems, datasets, repositories, services, simulations, and authorized infrastructure.
## 5. Tools Used
Only tools represented in the existing documentation or retained artifacts are treated as used.
## 6. Investigation / Methodology
The documented workflow is the methodology: evidence acquisition or generation, validation, analysis, interpretation, and reporting.
## 7. Commands / Scripts Used
Existing commands and scripts are retained in their documented locations; no execution is claimed merely because code exists.
## 8. Evidence
The retained evidence set consists only of the artifacts explicitly linked or described by this case study.
## 9. Indicators / Observations
Indicators and observations are limited to recorded results. Synthetic or simulated indicators remain labelled accordingly.
## 10. Analysis
Observed facts are separated from interpretation; unsupported conclusions are excluded.
## 11. Findings
Findings are those already supported by the retained evidence and documented analysis.
## 12. Risk / Impact
Risk statements are scoped to the documented environment. No production breach, customer impact, or employer engagement is implied.
## 13. Recommended Actions
Recommendations follow directly from documented findings, detection gaps, hardening needs, or validation requirements.
## 14. Detection / Monitoring Opportunities
Only demonstrated or explicitly proposed detection/monitoring opportunities are presented as such; unexecuted work remains pending.
## 15. MITRE ATT&CK Mapping
Existing justified ATT&CK mappings are retained; no mappings are invented to fill space.
## 16. Lessons Learned
Lessons reflect documented execution, troubleshooting, validation, and methodology.
## 17. Skills Demonstrated
Skills are limited to those supported by actual retained work and evidence.
## 18. Portfolio / SOC Relevance
The case study is framed as evidence of the corresponding security workflow without overstating professional experience.
## 19. Evidence & Limitations
**OFFLINE VALIDATION.** Evidence-state limitations, dataset constraints, unperformed steps, and environmental restrictions remain explicit.
## 20. References / Source Material
The existing linked artifacts, reports, scripts, datasets, standards, and source material remain authoritative.

### Evidence Integrity Statement

This standardization adds structure, not invented results. No fabricated metrics, certifications, incidents, production claims, or execution evidence are introduced.

## Reproducible Windows process-detection pack

The current starter pack adds testable detection logic and a portable Sigma artifact:

- [Python detection harness](./detections/detection_engine.py) — evaluates normalized Windows process-creation events.
- [Sigma rule](./detections/windows-suspicious-process.yml) — encoded PowerShell and remote-URL MSHTA patterns; validate field mapping before deployment.
- [Synthetic test fixtures](./fixtures/synthetic-process-events.json) — synthetic positive cases and benign controls.
- [Regression tests](./Tests/test_detection_engine.py) — verifies expected matches and non-matches.
- [Detection lifecycle and tuning standard](./DETECTION-LIFECYCLE.md) — proposal, testing, review, deployment, monitoring, tuning and retirement.
- [GitHub Actions quality workflow](../../.github/workflows/quality.yml) — runs the Python regression suite and validates fixture JSON.

### Run locally

From this directory:

```bash
python3 -m unittest discover -s Tests -v
python3 -m json.tool fixtures/synthetic-process-events.json > /dev/null
python3 detections/detection_engine.py fixtures/synthetic-process-events.json
python3 scripts/run_synthetic_hunt.py --check case-studies/synthetic-hunt-results.md
```

The harness is a training/reference implementation. Test fixtures are synthetic; matching a test event is not proof of malicious activity. The Sigma rule is marked `test` and is not approved for production deployment. Confirm event schema, field mapping, benign baselines and false-positive behaviour in the intended SIEM before operational use.

## Additional gap-closing evidence

- [Hypothesis-driven PowerShell hunt](./case-studies/hypothesis-driven-powershell-hunt.md) — documented hypothesis, data requirements, ATT&CK context, SPL starter query and test design.
- [Synthetic hunt results](./case-studies/synthetic-hunt-results.md) — deterministic outcomes for the five repository fixtures, with limitations clearly stated.
- [Endpoint-to-SIEM correlation checklist](./case-studies/endpoint-to-siem-correlation.md) — validation steps for endpoint telemetry, SIEM parsing and correlation; no live integration is claimed.
- [Offline alert enrichment utility](./automation/alert_enrichment.py) — classifies IP fields without external calls and leaves response in analyst-review mode.
- [Incident response and rule governance playbook](./INCIDENT-RESPONSE-LIFECYCLE.md) — triage, evidence handling, containment decision points, change governance and purple-team exercise template.

### Validation status

The repository's `quality.yml` workflow is configured to run the detection regression tests on pull requests and pushes to `main`. The test suite must be observed passing in that workflow before it is described as CI-validated. The separate Code Quality & Static Analysis and CodeQL runs do not, by themselves, prove that these detection tests ran.
