# Application Security Assessment: Static Analysis of This Portfolio's Own Codebase

> **Evidence classification: Real static-analysis scan + documented remediation**

## Scope

Bandit was run against the portfolio's Python automation and detection code. The assessment excludes `Coursework/` and `tests/` from the target scope.

**Tool:** Bandit 1.9.4  
**Analyst:** Hazvinei Masiya  
**Assessment date:** 2026-08-27

## Executive Summary

The initial scan identified **1 High, 3 Medium and 9 Low** findings. The actionable High finding in `Scripts/commit-lab.py` was remediated by replacing `shell=True` string execution with argument-list execution and `shell=False`.

Remaining findings were manually reviewed and documented according to their actual usage rather than mechanically suppressed.

## Key Finding and Remediation

### High — shell-injection pattern: RESOLVED

`run_cmd()` used `subprocess.run(..., shell=True, ...)` with string-built commands. Although current call sites used fixed strings, the pattern created unnecessary future injection risk.

**Remediation:** command arguments were changed to explicit argument lists with `shell=False`.

## Remaining Findings

- `B108` hardcoded temporary-directory pattern — reviewed as a false positive because the code excludes `/tmp` and `/var/tmp` from a file-auditing condition rather than writing to those paths.
- `B314/B405` XML parsing — accepted/documented because the validator processes locally authored Wazuh rule files; the limitation should be revisited if rule input becomes untrusted.
- Remaining low subprocess/path findings — reviewed as non-injection patterns in the current controlled usage.

## Final Result

Post-remediation scan: **0 High, 3 Medium (documented), 10 Low (documented)**.

The result is retained as scanner evidence rather than represented as a claim of zero findings.

## Evidence

- `Evidence/bandit-scan.json` — raw Bandit output
- `Evidence/bandit-scan.txt` — human-readable scan output

## Validation

- Pytest was run before and after the remediation.
- Bandit was rerun after the change.
- Medium/High findings were manually reviewed before disposition.

## Security Engineering Takeaway

Static-analysis output is a starting point for engineering review. Severity labels require contextual assessment, and remediation should reduce real risk without hiding unresolved findings.
