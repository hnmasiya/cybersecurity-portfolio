# Linux Forensic Investigation

## Executive Summary

This controlled laboratory demonstrates an evidence-backed Linux Digital Forensics and Incident Response workflow using synthetic forensic artifacts.

**Workflow:**

Evidence Acquisition -> Integrity Verification -> Timeline Analysis -> IOC Extraction -> Investigation -> MITRE ATT&CK Mapping -> Remediation -> Validation

No external malicious infrastructure was contacted.

## Scope

The investigation examines:

- SSH authentication failures
- Repeated authentication attempts
- Successful authentication
- Privileged command activity
- Shell history
- Suspicious domain references
- Evidence integrity
- IOC extraction
- Timeline correlation

## Evidence Inventory

| Artifact | Purpose |
|---|---|
| Evidence/auth.log | SSH authentication telemetry |
| Evidence/bash_history.txt | Shell activity |
| Evidence/system.log | Normalized system events |
| Evidence/suspicious-file.txt | Simulated suspicious artifact |
| Evidence/SHA256SUMS.txt | SHA-256 integrity manifest |
| Timeline/forensic-timeline.csv | Normalized forensic timeline |
| IOC/ioc-extraction.md | Extracted indicators |

## Evidence Integrity

The laboratory evidence was hashed using SHA-256.

Verification command:

    cd DFIR/Linux-Forensics/Evidence
    sha256sum -c SHA256SUMS.txt

All evidence files passed the integrity verification at the time of analysis.

## Timeline Analysis

The timeline shows three failed authentication attempts against the invalid `admin` account from `10.10.20.45`, followed by a successful SSH authentication for `analyst` from `10.10.20.10`.

A privileged command was subsequently executed by `analyst` to read `/etc/passwd`.

Later, the same source address `10.10.20.45` attempted authentication against the `root` account twice.

The repeated authentication failures from the same source are consistent with simulated credential-guessing activity.

## IOC Extraction

The investigation identified the following laboratory indicators:

### IP Addresses

- `10.10.20.45` - simulated suspicious authentication source
- `10.10.20.10` - simulated analyst workstation

### Domain

- `malicious.example.test` - fabricated laboratory domain

These indicators are synthetic and must not be treated as real malicious infrastructure.

## Investigation Findings

### Finding 1 — Repeated SSH Authentication Failures

Multiple failed authentication attempts originated from `10.10.20.45`.

**Assessment:** Suspicious authentication activity.

**Severity:** Medium

### Finding 2 — Root Account Targeting

The same source attempted authentication against the `root` account.

**Assessment:** Possible privilege-targeting activity.

**Severity:** High

### Finding 3 — Suspicious Payload Reference

Shell history contains a request for:

`http://malicious.example.test/payload.sh`

**Assessment:** Simulated suspicious payload retrieval.

**Severity:** High

### Finding 4 — Privileged Command

The `analyst` account executed:

`sudo cat /etc/passwd`

**Assessment:** Privileged account activity requiring contextual review.

**Severity:** Low / Informational

## MITRE ATT&CK Mapping

| Activity | MITRE ATT&CK Technique |
|---|---|
| Repeated SSH authentication attempts | T1110 - Brute Force |
| Valid account authentication | T1078 - Valid Accounts |
| Root account targeting | T1110 - Brute Force |
| Payload retrieval over HTTP | T1105 - Ingress Tool Transfer |
| Command execution through shell | T1059 - Command and Scripting Interpreter |

The mappings are analytical mappings for this controlled laboratory scenario and do not represent attribution to a real threat actor.

## Recommended Response

1. Block or investigate the suspicious source address.
2. Review SSH authentication logs for additional attempts.
3. Verify whether the successful `analyst` authentication was authorized.
4. Review privileged commands executed by the account.
5. Investigate the simulated payload reference.
6. Preserve affected evidence before modifying the system.
7. Rotate credentials if unauthorized access is confirmed.
8. Restrict direct root SSH authentication.
9. Implement rate limiting or other SSH brute-force protections.
10. Monitor subsequent authentication activity.

## Validation

The laboratory investigation is considered reproducible because the repository contains:

- Synthetic raw evidence
- SHA-256 integrity manifest
- Timeline data
- IOC extraction output
- IOC extraction script
- Investigation findings
- MITRE ATT&CK mappings
- Recommended remediation

## Limitations

This is a controlled synthetic laboratory.

No real compromise is claimed.

The IP addresses, domain name, authentication events and payload reference were created specifically for cybersecurity training.

The evidence demonstrates forensic methodology rather than a real-world incident.

## Conclusion

This investigation demonstrates a repeatable Linux DFIR workflow covering evidence preservation, integrity verification, timeline analysis, IOC extraction, investigation, MITRE ATT&CK mapping, remediation and validation.

The project provides practical evidence of forensic investigation capability suitable for a cybersecurity portfolio.
