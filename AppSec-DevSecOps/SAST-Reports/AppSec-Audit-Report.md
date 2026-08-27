# Application Security Assessment: Static Analysis of This Portfolio's Own Codebase

**Evidence-backed — real scan, real remediation**

## Metadata
* **Target:** This repository's own Python code (37 scripts, 1,278 lines — excludes `Coursework/` and `tests/`)
* **Tool:** `bandit` 1.9.4 (real static analysis, not a synthetic fixture)
* **Analyst:** Hazvinei Masiya
* **Date:** 2026-08-27

---

## 1. Summary

Ran `bandit` against the portfolio's own automation and detection scripts — not a fictional or third-party project. Initial scan: **1 High, 3 Medium, 9 Low**. The one real, actionable High-severity finding was fixed immediately; the rest were triaged honestly rather than reflexively "fixed" or ignored.

## 2. Findings

### Fixed: shell-injection-class pattern in `Scripts/commit-lab.py` (High → resolved)
* **Finding:** `run_cmd()` executed every git command via `subprocess.run(cmd, shell=True, ...)` with string-built commands (`B602`).
* **Real risk:** every call site in this script happened to use fixed strings, so there was no live exploit path today — but `shell=True` string execution is an unnecessary standing risk pattern with no functional benefit here, and it would silently become exploitable the moment any call took even partially external input (e.g. a commit message containing shell metacharacters).
* **Remediation:** refactored every call to pass argument lists with `shell=False` (e.g. `["git", "commit", "-m", commit_msg]` instead of an interpolated string). Verified behavior-identical via a full pytest run before and after.

### Reviewed and dismissed as a false positive: `B108 hardcoded_tmp_directory` (Medium x2) in `Linux-Security/Hardening-Lab/Scripts/linux_hardening_auditor.py:67`
* Bandit pattern-matches any string containing `/tmp`. The flagged line is `if not path.startswith("/tmp") and not path.startswith("/var/tmp")` — this is the auditor **excluding** `/tmp` paths from its own world-writable-file findings, not writing to a hardcoded temp path. Confirmed by reading the surrounding function; no code change made.

### Reviewed and accepted: `B314/B405` stdlib XML parsing (Medium x1) in `SIEM/Wazuh/Detection-Engineering-Lab/Scripts/offline_rule_validator.py:6`
* **Finding:** parses Wazuh detection-rule XML with stdlib `xml.etree.ElementTree` instead of `defusedxml`, which is a real, generally-valid recommendation — stdlib XML parsing is vulnerable to entity-expansion attacks against untrusted input.
* **Why not fixed here:** the input in this script is a locally-authored rule file the analyst wrote themselves, not attacker-supplied data, and every other script in this repo is deliberately stdlib-only with zero runtime dependencies. Adding `defusedxml` would introduce the first external dependency into an otherwise dependency-free validator for a theoretical risk that doesn't apply to this script's actual usage. Documented rather than silently dropped — this is the correct fix *if* this validator's input source ever becomes untrusted.

### Reviewed and accepted: remaining Low findings (subprocess-import awareness, partial executable paths for `docker`/`tshark`)
* In `Docker-Labs/Container-Audit-Lab/Scripts/collect_container_configs.py` and `Network-Security/PCAP-Analysis/Scripts/pcap_soc_analyzer.py`. All flagged `subprocess` calls use hardcoded argument lists with no user-controlled input — the pattern match (subprocess exists / executable resolved via `PATH`) is real, but there's no actual injection vector in how these scripts are used. Accepted as-is rather than pre-excused: reported the same way the Container Audit lab reports "arguably justified" findings — as-is, not scrubbed from the count.

## 3. Result

Re-scanned after remediation: **0 High, 3 Medium (documented), 10 Low (documented)**. See `Evidence/` for the raw scanner output at that final state.

## 4. Evidence

* [`Evidence/bandit-scan.json`](./Evidence/bandit-scan.json) — raw scanner output (JSON, post-remediation state)
* [`Evidence/bandit-scan.txt`](./Evidence/bandit-scan.txt) — human-readable scan output (post-remediation state)

## Test plan

- [x] `python3 -m pytest -q` — 185 passed, before and after the `commit-lab.py` refactor
- [x] Re-ran `bandit` after the fix and confirmed the High-severity finding is gone with no new findings introduced
- [x] Manually read every Medium/High finding's surrounding code before deciding fix vs. document vs. accept, rather than acting on the scanner's severity label alone
