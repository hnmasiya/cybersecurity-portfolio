# Linux Host Hardening Audit Lab

This project demonstrates an offline Linux host hardening audit using a
synthetic configuration snapshot, evaluated against CIS-benchmark-style
rules.

## Checks

- SSH root login permitted / password authentication enabled / legacy
  protocol version
- Unrestricted passwordless sudo (`NOPASSWD` on `ALL` commands)
- World-writable files outside `/tmp`
- SUID binaries not on the expected allowlist
- Legacy/insecure services running (telnet, rsh, rlogin, tftp, ...)
- Host firewall inactive

## Validation

Run:

`python3 Scripts/linux_hardening_auditor.py --input Data/synthetic-host-snapshot.json --output Evidence/hardening-audit.json`

Results are written to `Evidence/hardening-audit.json`.

## Current status

**Complete — validated against both synthetic and a real, live host.**

The synthetic snapshot includes both misconfigurations and
correctly-hardened settings (a scoped `NOPASSWD` sudo entry, allowlisted
SUID binaries, files under `/tmp`) to demonstrate the audit logic doesn't
flag ordinary, compliant configuration.

## Real host validation

[`Scripts/collect_host_snapshot.sh`](./Scripts/collect_host_snapshot.sh)
collects a real snapshot (SSH config via `sshd -T`, sudoers, SUID binaries,
running services, firewall state) from a live Linux host in the same JSON
schema, and was run against a real personal machine:

```
sudo ./Scripts/collect_host_snapshot.sh > Data/real-host-snapshot.json
python3 Scripts/linux_hardening_auditor.py --input Data/real-host-snapshot.json --output Evidence/real-hardening-audit.json
```

Result: **0 findings** across all 5 checks — but that's an earned result,
not an assumed one:

- No SSH server is installed on this host, so the SSH checks have nothing
  to flag (genuinely zero SSH attack surface, not a missing check).
- No `NOPASSWD` sudoers entries.
- `ufw` is active with default-deny incoming.
- No legacy/insecure services running.
- All 26 real SUID binaries were individually verified against their
  owning package (`dpkg -S`/`dpkg -L`) before being allowlisted — this
  caught two real issues along the way rather than assuming a clean
  result:
  - An unprivileged first scan looked artificially clean because it
    silently couldn't read into root-owned paths without `sudo` — a
    properly-privileged scan is what actually surfaced everything below.
  - The privileged scan then initially flooded the SUID/world-writable
    results with hundreds of false positives: `containerd` stores every
    Docker image layer as a plain directory tree under
    `/var/lib/containerd`, on the *same filesystem* as the host, so a
    naive `find -xdev` walks straight into every container image's own
    copy of `passwd`, `sudo`, `mount`, etc. The collector explicitly
    excludes `/var/lib/docker` and `/var/lib/containerd` to scope the
    audit to the actual host, not container-internal storage.
  - One binary, `/usr/lib/mysql/plugin/auth_pam_tool_dir/auth_pam_tool`,
    only appeared once the scan ran as root (its permissions are
    restrictive enough that even `find` can't see it unprivileged) and
    was verified as belonging to the `mariadb-server` package before
    being allowlisted.

Real evidence: [`Data/real-host-snapshot.json`](./Data/real-host-snapshot.json)
(the real collected snapshot) and
[`Evidence/real-hardening-audit.json`](./Evidence/real-hardening-audit.json)
(the audit result).


---

# 20-Section Evidence-First Case Study Record

> **Standard:** Permanent portfolio case-study standard. This record maps the existing lab evidence to the required 20-section structure without inventing execution claims.

**Evidence state:** LIVE / REAL LAB

## 1. Scenario
The scenario documented in this README is authoritative; no new scenario is inferred.
## 2. Business / Technical Context
The documented technical environment and training/business context above define scope. Production impact is not claimed unless evidenced.
## 3. Objective
The objective is the explicitly documented investigation, validation, detection, engineering, or monitoring outcome.
## 4. Environment / Scope
Only explicitly named hosts, datasets, services, indexes, tools, and authorized systems are in scope.
## 5. Tools Used
Only tools evidenced in the existing README and retained artifacts are treated as used.
## 6. Investigation / Methodology
Follow the documented workflow: collect or generate authorized data, analyze, validate, interpret, and preserve evidence.
## 7. Commands / Scripts Used
Commands and scripts remain in their existing paths; execution is claimed only where the lab already records it.
## 8. Evidence
Retained datasets, screenshots, reports, rules, scripts, outputs, and logs referenced by the lab are the evidence set.
## 9. Indicators / Observations
Only observed results from retained evidence are recorded as indicators or observations.
## 10. Analysis
Analysis distinguishes raw observations from interpretation and preserves benign explanations where supported.
## 11. Findings
Findings are limited to those documented in the lab's existing analysis and evidence.
## 12. Risk / Impact
Risk is scoped to the lab. No customer, employer, breach, or production-impact claim is inferred.
## 13. Recommended Actions
Actions are the documented remediation, tuning, hardening, validation, or follow-up measures supported by findings.
## 14. Detection / Monitoring Opportunities
Detection and monitoring opportunities are those demonstrated or explicitly proposed; pending detections remain pending.
## 15. MITRE ATT&CK Mapping
Existing justified mappings are retained. No unsupported techniques are added.
## 16. Lessons Learned
Lessons derive from documented execution, troubleshooting, validation, or methodology, including useful failed approaches.
## 17. Skills Demonstrated
Skills are limited to capabilities evidenced by the actual lab artifacts and execution record.
## 18. Portfolio / SOC Relevance
The lab demonstrates the relevant SOC/security workflow without converting training evidence into production experience.
## 19. Evidence & Limitations
**LIVE / REAL LAB.** Synthetic/offline evidence remains synthetic/offline; dataset and environmental limitations remain explicit.
## 20. References / Source Material
Existing linked artifacts, datasets, scripts, reports, standards, and source material remain the authoritative references.

### Evidence Integrity Statement
No fabricated metrics, incidents, certifications, production claims, or execution results are introduced by this standardization.
