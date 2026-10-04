# Portfolio Evidence Integrity Audit — 2026-10-04

## Purpose
This audit reconciles the portfolio's published project claims against the existing master completion/evidence register. It is a documentation-quality audit, not a new execution of the labs.

## Evidence classification
| Area | Current evidence state | Action |
|---|---|---|
| Splunk Labs 01–06 | Executed / controlled synthetic | Keep explicit synthetic boundary; standardized Labs 03–06 |
| Wazuh offline detection engineering | Offline validation | Do not imply live Manager execution for offline rules |
| Wazuh live endpoint integration | Live / real lab | Retain Azure-to-Wazuh evidence |
| Windows / Sysmon | Live / real lab + synthetic | Retain real telemetry and contextual triage |
| Active Directory detection | Live / real lab + synthetic | Retain raw events and explain benign administrative findings |
| SOC Flagship LSASS investigation | Live / real lab | Retain event-to-rule-to-ATT&CK evidence |
| Linux hardening | Live / real lab + synthetic | Retain collector output and methodology limitations |
| Docker audit | Live / real lab + synthetic | Retain sanitized findings and explain intentional privileged access |
| DVWA | Evidence track complete | Preserve vulnerability reports/screenshots; standardize remaining presentation where needed |
| Nmap | Supporting evidence | Verify canonical README path and link |
| Wireshark / PCAP | Supporting evidence | Verify canonical README path and link |
| Threat Hunting | Offline validation | Do not imply live enterprise telemetry |
| Azure Windows Server | Live / real lab | Retain deployment, AD, Security, Sysmon and Wazuh evidence |
| GCP Project Security | IaC validated, not applied | Keep plan/apply gap explicit |
| GCP Landing Zone | Architecture / prepared | Do not imply organization-level deployment |
| Cloud Detection | Offline validation | Synthetic audit-log detection validated; keep live deployment boundary explicit |
| IOC Investigation | Controlled / synthetic | Synthetic indicators normalized and format-validated; no maliciousness verdict or external enrichment claimed |
| Phishing / Email Investigation | Controlled / synthetic | Synthetic headers analyzed offline; no live mailbox activity claimed |
| SOC Automation | Controlled / synthetic | Core triage workflow executed against retained synthetic alerts; item-level evidence remains bounded |
| Bandit / SAST | Live / real lab | Retain final scan/remediation evidence |
| AD Security Log Parser | Supporting project | Keep parser/test-data boundary explicit |
| Mastercard / Datacom | Virtual experience | Present separately from employment and independent labs |
| Deloitte / AIG | Virtual experience | Present separately from employment and independent labs |

## Integrity rules applied
- No fabricated evidence.
- No invented metrics.
- No unsupported certifications or employment claims.
- No simulated incident presented as a real incident.
- No recommendation presented as an executed remediation.
- No production performance claim from synthetic telemetry.
- Planned work remains planned until evidence exists.

## Remaining evidence-quality work
1. Reconcile any stale links to canonical lab READMEs.
2. Standardize remaining high-value lab READMEs using the permanent case-study standard.
3. Ensure every featured project has an obvious evidence path within one or two clicks.
4. Keep pending projects visibly marked until execution is evidenced.
5. Run the repository QA/security checks before publication.

## Audit conclusion
The portfolio has a strong evidence-first foundation. The remaining work is primarily consistency, navigation and presentation—not manufacturing additional claims.