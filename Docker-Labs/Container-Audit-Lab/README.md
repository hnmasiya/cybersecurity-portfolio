# Container Configuration Security Audit Lab

This project demonstrates an offline container security audit using
synthetic container build/runtime configuration, covering common
misconfigurations from the CIS Docker Benchmark and MITRE ATT&CK for
Containers.

## Checks

- Container runs as root (missing/`root` `USER`)
- Unpinned base image tag (`latest` or no tag)
- Hardcoded secret in an environment variable
- Container running in privileged mode
- Docker socket mounted into the container (classic escape vector)
- Container using host network mode

Findings are mapped to MITRE ATT&CK where applicable.

## Validation

Run:

`python3 Scripts/container_config_auditor.py --input Data/synthetic-container-configs.json --output Evidence/container-audit.json`

Results are written to `Evidence/container-audit.json`.

## Current status

**Complete — validated against both synthetic and a real, live Docker host.**

The synthetic dataset includes one fully-hardened container config (pinned
tag, non-root user, a non-secret env value, no privileged mode, no
docker.sock mount, bridge networking) to demonstrate the audit logic
doesn't flag correctly-configured containers.

## Real Docker host validation

[`Scripts/collect_container_configs.py`](./Scripts/collect_container_configs.py)
collects real running-container configuration via `docker inspect`
(image, user, env var key names, privileged flag, mounts, network mode),
transformed into the schema the auditor expects, and was run against a
real home-lab Docker host running 8 containers (Wazuh Manager/
Indexer/Dashboard, RustDesk relay/signal servers, Portainer, Juice Shop,
Wireshark):

```
python3 Scripts/collect_container_configs.py > Data/real-container-configs.json
python3 Scripts/container_config_auditor.py --input Data/real-container-configs.json --output Evidence/real-container-audit.json
```

Result: **14 findings across 8 containers** (1 CRITICAL, 10 HIGH, 3 MEDIUM)
— real, unfiltered output, interpreted honestly:

- **5 containers running as root** (`wazuh-manager`, `hbbs`/`hbbr`
  RustDesk relay/signal servers, `portainer`, `wireshark`) — genuine
  findings. Two of them (`portainer`, `wireshark`) are arguably
  justified by what the container needs to do (Portainer manages the
  Docker daemon itself; Wireshark needs raw packet-capture access), but
  "needed for the job" and "not a real finding" are different things —
  both are reported as-is rather than pre-excused.
- **5 hardcoded secrets** (`INDEXER_PASSWORD`, `API_PASSWORD` on the
  Manager; `INDEXER_PASSWORD`, `DASHBOARD_PASSWORD`, `API_PASSWORD` on
  the Dashboard) — these are literal plaintext passwords in the Wazuh
  official Docker Compose quickstart's environment variables, a real
  and known tradeoff of that deployment pattern, not a mistake unique to
  this lab.
- **1 CRITICAL: Docker socket mounted into `portainer`** — genuine and
  by design: Portainer requires access to the Docker socket to manage
  containers on the host, which is exactly the classic container-escape
  vector this check exists to catch. A real, accepted risk tradeoff for
  running Portainer at all, not an oversight.
- **3 unpinned (`latest`) image tags** (`portainer`, `juice-shop`,
  `wireshark`) — realistic for a home lab pulling current images rather
  than pinning to specific digests.
- **`wazuh-indexer` produced zero findings** — not every container in
  the same stack is flagged; a raw, unfiltered auditor still correctly
  distinguishes a clean config from a flagged one.

The collector never writes real secret values to disk: env var values
are replaced with a fixed sentinel before being written, while still
preserving the fact that a real, non-empty value was set - which is all
the CTR-003 check actually needs. Real evidence:
[`Data/real-container-configs.json`](./Data/real-container-configs.json)
and [`Evidence/real-container-audit.json`](./Evidence/real-container-audit.json).


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
