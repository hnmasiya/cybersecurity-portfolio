# Phase 2 — Linux Process Investigation

Investigation evidence generated from a controlled local Linux host.

## Evidence

The directory contains process, filesystem, socket, HTTP, lineage, executable
hash, findings, and SHA-256 manifest artifacts.

Key evidence files:

- `process-summary.txt`
- `process-lineage.txt`
- `listening-sockets.txt`
- `lsof.txt`
- `proc-cmdline.txt`
- `proc-cwd.txt`
- `proc-exe.txt`
- `proc-root.txt`
- `proc-status.txt`
- `findings.txt`
- `SHA256SUMS.txt`

## Integrity

```bash
cd "evidence/phase2-linux-process-investigation-20260924-131215"
sha256sum -c SHA256SUMS.txt
```

This README describes retained artifacts and does not change their findings.


---

# 20-Section Evidence-First Case Study Record

> Permanent case-study standard mapping. Existing content and artifacts remain authoritative; this section introduces no new execution claims.

**Evidence state:** CONTROLLED / SYNTHETIC

## 1. Scenario
Use only the documented scenario above.
## 2. Business / Technical Context
Use only the documented technical/training context; no production impact is inferred.
## 3. Objective
Use the documented objective without expanding scope.
## 4. Environment / Scope
Only explicitly documented systems, datasets, services, simulations, and authorized infrastructure are in scope.
## 5. Tools Used
Only tools evidenced by documentation or retained artifacts are treated as used.
## 6. Investigation / Methodology
Follow the documented acquisition/generation, validation, analysis, interpretation, and reporting workflow.
## 7. Commands / Scripts Used
Existing commands and scripts remain authoritative; code existence alone is not execution evidence.
## 8. Evidence
Only retained and referenced datasets, screenshots, reports, rules, scripts, outputs, and logs are evidence.
## 9. Indicators / Observations
Only recorded observations are presented; synthetic indicators remain synthetic.
## 10. Analysis
Separate observations from interpretation and preserve supported benign explanations.
## 11. Findings
Only findings supported by retained evidence are stated.
## 12. Risk / Impact
Scope risk to the lab; do not infer customer, employer, breach, or production impact.
## 13. Recommended Actions
Recommendations follow from documented findings and validation gaps.
## 14. Detection / Monitoring Opportunities
Only demonstrated or explicitly proposed opportunities are presented; unexecuted work remains pending.
## 15. MITRE ATT&CK Mapping
Retain only justified existing mappings.
## 16. Lessons Learned
Derive lessons from documented execution, troubleshooting, validation, and methodology.
## 17. Skills Demonstrated
Claim only skills evidenced by retained work.
## 18. Portfolio / SOC Relevance
Map the evidence to the relevant security workflow without overstating professional experience.
## 19. Evidence & Limitations
**CONTROLLED / SYNTHETIC.** Preserve dataset, environment, telemetry, and unperformed-step limitations.
## 20. References / Source Material
Existing linked artifacts, reports, scripts, datasets, standards, and source material remain authoritative.

### Evidence Integrity Statement
No fabricated metrics, incidents, certifications, production claims, or execution results are introduced.
