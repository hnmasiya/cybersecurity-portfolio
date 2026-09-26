# Cybersecurity Portfolio — Master Lab Completion & Evidence Project

**Repository:** hnmasiya/cybersecurity-portfolio  
**Owner:** Hazvinei Nomatter Masiya  
**Purpose:** authoritative evidence-first register of the portfolio's cybersecurity labs/projects, their real execution state, supporting evidence, and completion gates.

## 1. Evidence states

| State | Meaning |
|---|---|
| COMPLETED — LIVE / REAL LAB | Executed in an authorized real lab with retained evidence. |
| COMPLETED — CONTROLLED / SYNTHETIC | Executed with controlled/synthetic data and retained validation evidence. |
| COMPLETED — OFFLINE VALIDATION | Detection/analysis validated offline against controlled fixtures. |
| ARCHITECTURE / PREPARED | Design/code exists but required deployment/execution evidence is missing. |
| PENDING VALIDATION | Workflow/partial work exists but one or more required tests remain. |
| VIRTUAL EXPERIENCE | Third-party simulation/program; separate from employment and hands-on lab claims. |

Never invent timestamps, screenshots, alerts, detection rates, incidents, production telemetry, compromise claims, or remediation results.

## 2. Universal definition of a complete lab

A lab is publicly labelled COMPLETE only when all applicable gates below are satisfied.

### Objective and scope
- [ ] Objective and security scenario documented.
- [ ] Authorized scope documented.
- [ ] Out-of-scope systems identified where relevant.
- [ ] Safety/responsible-use boundary documented.
- [ ] Real, synthetic and simulated evidence separated.

### Environment
- [ ] Host/target OS documented.
- [ ] Application/system documented.
- [ ] Network/topology documented where relevant.
- [ ] Versions/dependencies documented.
- [ ] Reproducible setup documented.
- [ ] Secrets are excluded from Git.

### Tooling
- [ ] Tools and important versions documented.
- [ ] Configuration/scripts retained.
- [ ] Installation/setup steps documented.
- [ ] Community/external configuration sources attributed.

### Baseline and execution
- [ ] Normal/benign baseline established where relevant.
- [ ] Expected behaviour documented.
- [ ] Actual procedure executed.
- [ ] Commands/queries/scripts retained or documented.
- [ ] Actual inputs identified.
- [ ] Failed attempts/fixes documented where material.

### Evidence
- [ ] Raw/sanitized inputs retained.
- [ ] Relevant command/query output retained.
- [ ] Detection/analysis output retained.
- [ ] Screenshots retained only when genuinely captured.
- [ ] Structured JSON/CSV evidence retained where useful.
- [ ] Final report retained.
- [ ] Evidence index maps artifacts to claims.

### Detection / investigation
- [ ] Detection/analytic logic retained.
- [ ] Expected result defined.
- [ ] Actual result recorded.
- [ ] False positives considered.
- [ ] Initial hypothesis documented.
- [ ] Timeline reconstructed where relevant.
- [ ] User/account, host/process and network context reviewed where available.
- [ ] Benign explanation considered.
- [ ] Scope and evidence limitations documented.

### ATT&CK / remediation / validation
- [ ] ATT&CK mapping is justified by observed behaviour.
- [ ] Root cause documented.
- [ ] Remediation recommendation documented.
- [ ] Actual remediation distinguished from recommendation.
- [ ] Primary success criteria listed.
- [ ] Expected vs actual compared.
- [ ] Re-run performed after material fixes.
- [ ] Negative/benign controls run where relevant.
- [ ] Validation artifact retained.

### Publication / QA
- [ ] Links and local references validated.
- [ ] Bash/Python/JSON/YAML/XML checks performed where applicable.
- [ ] Security scan performed where appropriate.
- [ ] Secrets/private/customer/employer data removed.
- [ ] README status matches evidence.
- [ ] CI/quality checks pass.
- [ ] Portfolio index/evidence map updated.

## 3. Current lab/project register

| Project | Current state | Completion evidence / remaining work |
|---|---|---|
| Splunk Lab 01 — SSH Authentication Hunting | COMPLETED | 31 synthetic events; SPL; report; dashboard validation; evidence retained. |
| Splunk Lab 02 — Windows/Sysmon Process Investigation | COMPLETED with presentation gap | Investigation/detection artifacts exist; dashboard screenshot remains intentionally unchecked. |
| Splunk Lab 03 — Web Attack / HTTP Investigation | COMPLETED at track level; README reconciliation needed | 15 validated events and artifacts; individual README still says prepared. |
| Splunk Lab 04 — Detection Engineering / SPL Alert Logic | COMPLETED at track level; README reconciliation needed | 6 validated events, rules and report; individual README still says prepared. |
| Splunk Lab 05 — Dashboarding / SOC Monitoring | COMPLETED at track level; README reconciliation needed | 24 validated events and monitoring artifacts; individual README still says prepared. |
| Splunk Lab 06 — End-to-End SOC Investigation | COMPLETED at track level; README reconciliation needed | 6 validated case events, SPL and incident report; individual README still says prepared. |
| Wazuh Detection Engineering — Offline | COMPLETED — OFFLINE VALIDATION | XML rules, validator, JSON/CSV evidence; live Manager validation is separate. |
| Wazuh live endpoint integration | COMPLETED — LIVE / REAL LAB | Azure endpoint connected to Wazuh Manager via Tailscale with real alert/SCA evidence. |
| Windows / Sysmon Endpoint Detection | COMPLETED — LIVE / REAL LAB + SYNTHETIC | 16 real events and 5 findings; offline validation also retained. |
| Active Directory Security Event Detection | COMPLETED — LIVE / REAL LAB + SYNTHETIC | 409 real Security events and 392 analyzer findings with contextual triage. |
| SOC Flagship Investigation — LSASS | COMPLETED — LIVE / REAL LAB | Sysmon Event 10 to Wazuh Rule 100312, Level 13, T1003.001; timeline/report retained. |
| Linux Host Hardening Audit | COMPLETED — LIVE / REAL LAB + SYNTHETIC | Real privileged collection; 0 findings after scoped audit; evidence retained. |
| Docker Container Configuration Audit | COMPLETED — LIVE / REAL LAB + SYNTHETIC | 14 real findings across 8 containers; secrets sanitized. |
| DVWA Web Security | COMPLETED evidence track | Multiple vulnerability reports and genuine screenshot/evidence inventory. |
| Nmap reconnaissance | COMPLETED supporting evidence | Real full-TCP-range self-owned scan; master index had a path warning. |
| Wireshark / PCAP Analysis | COMPLETED supporting evidence | Real project traffic capture and PCAP analysis; master index had a path warning. |
| Threat Hunting & Detection Validation | COMPLETED — OFFLINE VALIDATION | HUNT-001/002/003 validator plus JSON/CSV output. |
| Azure Windows Server Security Lab | COMPLETED — LIVE / REAL LAB | Windows Server 2022 DC deployed/hardened with Security, Sysmon and Wazuh evidence. |
| GCP Secure Landing Zone | ARCHITECTURE / PREPARED | Terraform/design ready; real GCP organization deployment not evidenced. |
| Cloud Detection | PENDING VALIDATION | Candidate scenarios documented; live detection execution remains. |
| IOC Investigation | PENDING VALIDATION | Workflow documented; executed enrichment case not established. |
| Controlled Phishing / Email Investigation | PENDING VALIDATION | 16-section workflow exists; executed case evidence remains. |
| SOC Automation | COMPLETED framework; item-level evidence varies | Each automation needs inputs, processing, outputs, errors, tests and limits. |
| AppSec/SAST — Bandit | COMPLETED — LIVE / REAL LAB | High issue remediated; final 0 High, 3 Medium, 10 Low documented. |
| Active Directory Security Log Parser | COMPLETED supporting project | Event 4728 parser, syntax validation and sanitized test data. |
| Wazuh SIEM Detection Lab | COMPLETED supporting project | Wazuh/AD detection concept and ATT&CK mapping. |
| GCP Secure Multi-Tier VPC | ARCHITECTURE / METHODOLOGY | Secure VPC design; not deployment evidence. |
| Mastercard Cybersecurity Job Simulation | VIRTUAL EXPERIENCE — COMPLETED | Phishing simulation design plus campaign-results interpretation/training. |
| Datacom Cyber Security Operations Job Simulation | VIRTUAL EXPERIENCE — COMPLETED | Simulated ransomware investigation plus 5x5 risk assessment. |

## 4. Splunk SOC Lab Track

Progression:

Authentication Hunting -> Endpoint Investigation -> Web Investigation -> Detection Engineering -> SOC Monitoring -> End-to-End Investigation

### Lab 01 — SSH Authentication Threat Hunting

Required:
- [x] Authorized Splunk instance.
- [x] Synthetic dataset ingested.
- [x] Event-time extraction verified.
- [x] Dedicated lab index and sourcetype.
- [x] Failure aggregation.
- [x] Source/account analysis.
- [x] Timeline.
- [x] Visualization.
- [x] Findings/report.
- [x] Evidence retained.
- [x] Dashboard executed and validated.

Observed:
- 31 events.
- 21 failures.
- 10 successes.
- Source 10.10.10.25: 8 failures.
- admin: 7 failed attempts overall.
- Focused timeline: 9 events, including 8 failures and one successful admin authentication.
- Dashboard: 7 visualizations, 7 data sources, 1 tab, 7 panels.
- Token/schema validation: zero unresolved references.

**Status: COMPLETE.**

### Lab 02 — Windows / Sysmon Process Investigation

Required:
- [x] Synthetic Sysmon dataset.
- [x] Dedicated index.
- [x] Ingestion.
- [x] Process creation investigation.
- [x] Parent/child analysis.
- [x] PowerShell investigation.
- [x] Suspicious command-line analysis.
- [x] Detection-oriented SPL.
- [x] Report.
- [x] Dashboard definition.
- [x] Dashboard REST validation attempted.
- [ ] Genuine dashboard screenshot.

Artifacts include process-investigation.spl, detection-rules.spl, report, dashboard documentation and Dashboard Studio JSON.

**Status: COMPLETE for executed investigative/detection work; screenshot remains a presentation gap.**

### Lab 03 — Web Attack / HTTP Investigation

Required:
- [ ] Import 15-event dataset.
- [ ] Verify index splunk_lab_web.
- [ ] Verify sourcetype splunk:lab:web.
- [ ] Run baseline and attack-family searches.
- [ ] Identify suspicious sources/patterns.
- [ ] Reconstruct timeline.
- [ ] Validate expected observations.
- [ ] Render investigation/dashboard.
- [ ] Retain report/SPL/evidence.
- [ ] Capture visual proof only if genuinely executed.

Track-level validation already identifies this lab as executed with 15 validated events. The individual README still contains stale "prepared for local execution" wording.

**Status: COMPLETE at track level; reconcile documentation.**

### Lab 04 — Detection Engineering / SPL Alert Logic

Required:
- [ ] Import 6 synthetic events.
- [ ] Verify index and sourcetype.
- [ ] Execute detection SPL.
- [ ] Validate expected alerts.
- [ ] Test benign controls.
- [ ] Compare expected vs actual.
- [ ] Document false positives/tuning.
- [ ] Render and retain investigation/dashboard evidence.

Track-level evidence identifies 6 validated events, detection rules and a validation report; individual README wording is stale.

**Status: COMPLETE at track level; reconcile documentation.**

### Lab 05 — Dashboarding / SOC Monitoring

Required:
- [ ] Ingest 24 synthetic SOC-metric events.
- [ ] Verify index/sourcetype.
- [ ] Validate count.
- [ ] Execute KPI/time-series SPL.
- [ ] Build dashboard.
- [ ] Verify data sources/visualizations/layout.
- [ ] Validate tokens/schema.
- [ ] Retain monitoring report and genuine visual evidence.

Track-level evidence identifies 24 validated events and monitoring artifacts; individual README wording is stale.

**Status: COMPLETE at track level; reconcile documentation.**

### Lab 06 — End-to-End SOC Investigation

Required:
- [ ] Ingest 6 synthetic case events.
- [ ] Verify index/sourcetype.
- [ ] Establish hypothesis.
- [ ] Run timeline/sequence searches.
- [ ] Correlate indicators.
- [ ] Validate observations.
- [ ] Render investigation view.
- [ ] Retain incident report/evidence.
- [ ] Document scope, limits and response.

Track-level evidence identifies 6 validated case events, SPL and incident-report artifacts; individual README wording is stale.

**Status: COMPLETE / CONTROLLED at track level; reconcile documentation.**

## 5. Wazuh Detection Engineering — Offline

Architecture:

Controlled event -> XML rule -> Python validation harness -> expected/actual -> JSON/CSV -> SOC interpretation

Rules:
- 100001: if_sid 5710, level 10.
- 100002: match Failed password, level 12.

Completed:
- [x] XML parsing.
- [x] Controlled event loading.
- [x] Rule-condition evaluation.
- [x] Expected/actual comparison.
- [x] JSON and CSV evidence.
- [x] Rerunnable validator.
- [x] Successful-login control.
- [x] ATT&CK and false-positive context.
- [x] Production-validation gap documented.

Test cases EVT-001, EVT-002 and EVT-003 all PASS.

Not demonstrated here:
- live Wazuh Manager,
- wazuh-logtest,
- live alert generation,
- frequency/correlation,
- production tuning.

**Status: COMPLETE — OFFLINE VALIDATION.**

## 6. Azure Windows Server + AD + Sysmon + Wazuh

Environment:
- Windows Server 2022.
- Azure VM.
- AD Domain Controller.
- lab.local.
- Default-deny NSG.
- RDP limited to admin source CIDR.
- Auto-shutdown.
- Tailscale private mesh for Wazuh.

Completed:
- [x] Terraform deployment.
- [x] VM provisioning.
- [x] AD promotion.
- [x] Hardening baseline.
- [x] Security log export.
- [x] Sysmon installation.
- [x] Sysmon export.
- [x] Wazuh Agent installation.
- [x] Private Manager connectivity.
- [x] Manager-side active-agent evidence.
- [x] Wazuh alert/SCA evidence.
- [x] Azure resource inventory.

Real Security telemetry:
- 409 events.
- 392 analyzer findings: 1 Critical, 16 High, 375 Medium.
The repository explains these largely as normal domain-controller promotion/service activity, not proof of compromise.

Real endpoint telemetry:
- 16 events.
- 5 findings: EDR-004 x1, EDR-002 x3, EDR-003 x1.
The findings are documented as explainable lab activity.

**Status: COMPLETE — LIVE / REAL LAB.**

## 7. Active Directory Detection

Coverage:
- 4625 failed authentication.
- 4771 Kerberos pre-auth failure.
- 4769 possible Kerberoasting.
- 4728/4732/4756 privileged group changes.
- 4720 new users.
- 4672 special privileges.
- 1102 audit log cleared.

Completed:
- [x] Synthetic analysis.
- [x] Detection logic.
- [x] Real Azure Security analysis.
- [x] Contextual triage.
- [x] ATT&CK mappings.
- [x] Evidence and limitations.

**Status: COMPLETE — LIVE / REAL LAB + SYNTHETIC.**

## 8. Windows / Sysmon Endpoint Detection

Scenarios:
- Suspicious PowerShell.
- PowerShell network activity.
- Failed authentication.
- PowerShell child process.

Completed:
- [x] Synthetic validator.
- [x] Expected outcomes.
- [x] JSON validation evidence.
- [x] Real Azure capture.
- [x] 16 real events.
- [x] 5 findings.
- [x] Contextual interpretation.

**Status: COMPLETE — LIVE / REAL LAB + SYNTHETIC.**

## 9. SOC Flagship Investigation — LSASS

Observed chain:

PowerShell -> LSASS access -> Sysmon Event 10 -> Wazuh Agent -> Rule 100312 -> Level 13 -> T1003.001

Completed:
- [x] Event 10 observed.
- [x] Source/target identified.
- [x] GrantedAccess 0x1010 recorded.
- [x] Wazuh alert observed.
- [x] Timeline reconstructed.
- [x] ATT&CK mapped.
- [x] Scope assessed.
- [x] Alternative explanation considered.
- [x] Response decision documented.
- [x] Detection improvement documented.

Observed host: dc01-lab.lab.local. Two relevant process-access events are retained in the case evidence.

The case validates the telemetry-to-detection pipeline. It does not demonstrate credential dumping, successful extraction, persistence, lateral movement or command-and-control.

**Status: COMPLETE — LIVE / REAL LAB.**

## 10. Linux Host Hardening

Checks:
- SSH root/password/legacy protocol.
- NOPASSWD sudo.
- World-writable files outside temporary paths.
- Unexpected SUID binaries.
- Legacy/insecure services.
- Firewall.

Completed:
- [x] Synthetic snapshot and audit.
- [x] Real privileged snapshot.
- [x] Real audit.
- [x] False-positive investigation.
- [x] Package verification of SUID binaries.
- [x] Container-storage scoping.
- [x] Real evidence retained.

Real result: 0 findings after proper scoped/privileged collection.

**Status: COMPLETE — LIVE / REAL LAB + SYNTHETIC.**

## 11. Docker Container Configuration Audit

Checks:
- Root user.
- Unpinned image.
- Hardcoded environment secret.
- Privileged mode.
- Docker socket mount.
- Host networking.

Completed:
- [x] Synthetic fixtures.
- [x] Auditor.
- [x] Real docker inspect collection.
- [x] Real audit.
- [x] Secret sanitization.
- [x] Finding interpretation.

Real result: 14 findings across 8 containers: 1 Critical, 10 High, 3 Medium.

**Status: COMPLETE — LIVE / REAL LAB + SYNTHETIC.**

## 12. DVWA Web Security

Environment:
- Zorin OS.
- Apache 2.4.58.
- PHP 8.3.6.
- MariaDB 10.11.14.
- DVWA.
- Burp Suite Community Edition.

Documented vulnerability areas:
- Brute Force.
- Command Injection.
- CSRF.
- File Inclusion.
- File Upload.
- SQL Injection.
- Weak Session ID.
- Reflected XSS.
- Stored XSS.
- DOM XSS.
- Insecure CAPTCHA.

Required report format:
1. Objective
2. Skills/tools
3. Architecture
4. Topology
5. Execution
6. Walkthrough
7. Attack simulation
8. Detection
9. Triage
10. Investigation
11. Evidence
12. Findings
13. Impact
14. Root cause
15. MITRE ATT&CK
16. Remediation
17. Validation
18. Lessons learned
19. Recommendations

The repository evidence inventory contains genuine screenshots for login, brute force, command injection, CSRF, file inclusion, file upload, CAPTCHA, SQL injection, weak session and XSS variants.

**Status: COMPLETE evidence track.**

## 13. Network Security

### Nmap
- [x] Authorized/self-owned scope.
- [x] Full TCP-range scan.
- [x] Results interpreted.
- [x] Evidence retained.

### Wireshark / PCAP
- [x] Authorized project traffic capture.
- [x] PCAP retained.
- [x] Protocol/connection analysis.
- [x] IOC extraction where applicable.
- [x] Findings documented.

Master audit previously warned that Nmap and Wireshark cross-domain paths were absent. Repair the index/reference mapping and rerun the master audit.

**Status: COMPLETE supporting evidence; indexing cleanup remains.**

## 14. Threat Hunting & Detection Validation

Hunts:
- Repeated failed authentication.
- Encoded PowerShell.
- PowerShell network activity.

Completed:
- [x] Synthetic hunt data.
- [x] HUNT-001 threshold logic.
- [x] HUNT-002 encoded PowerShell.
- [x] HUNT-003 network activity.
- [x] JSON evidence.
- [x] CSV evidence.
- [x] PASS/FAIL validation.
- [x] CI/QA integration.
- [x] Limitations.

**Status: COMPLETE — OFFLINE VALIDATION.**

## 15. AppSec / DevSecOps — Bandit

Completed:
- [x] Scope defined.
- [x] Bandit 1.9.4 executed.
- [x] Raw evidence retained.
- [x] High finding investigated.
- [x] High finding remediated.
- [x] Tests rerun.
- [x] Bandit rerun.
- [x] Remaining findings manually reviewed.

Initial:
- 1 High.
- 3 Medium.
- 9 Low.

The High issue was unnecessary shell=True use in Scripts/commit-lab.py.

Final:
- 0 High.
- 3 Medium documented.
- 10 Low documented.

Do not describe this as "zero findings".

**Status: COMPLETE — LIVE / REAL LAB.**

## 16. Standalone Active Directory Security Log Parser

Completed:
- [x] Windows Security XML parsing.
- [x] Event 4728 filtering.
- [x] Timestamp extraction.
- [x] Added account extraction.
- [x] Security group extraction.
- [x] Actioning account extraction.
- [x] SOC-style output.
- [x] Multiple events.
- [x] Missing/malformed input handling.
- [x] Syntax validation.
- [x] Sanitized test data.
- [x] Benign-activity interpretation.

**Status: COMPLETE supporting project.**

## 17. SOC Automation

Target workflow:

Alert/log -> parse -> normalize -> IOC extraction -> enrichment -> classification -> prioritization -> analyst summary -> case/report

Every automation is complete only when:
- [ ] Problem statement.
- [ ] Manual baseline.
- [ ] Inputs.
- [ ] Processing.
- [ ] Outputs.
- [ ] Error handling.
- [ ] Tests.
- [ ] Limitations.
- [ ] Security controls.
- [ ] Human decision point for consequential actions.
- [ ] Reproducible example.

Do not claim measured time savings, accuracy, false-positive reduction or automated containment without measured evidence.

**Status: COMPLETE framework; item-level evidence varies.**

## 18. GCP Secure Landing Zone

Current state is **ARCHITECTURE / PREPARED**, not deployed.

Required for completion:
- [ ] Real GCP organization.
- [ ] Billing attached.
- [ ] gcloud authenticated.
- [ ] Terraform registry reachable.
- [ ] terraform init.
- [ ] terraform validate.
- [ ] terraform plan -out=tfplan.
- [ ] Plan reviewed.
- [ ] terraform apply tfplan.
- [ ] Five folders created.
- [ ] Shared VPC created.
- [ ] Centralized logging project.
- [ ] Cloud NAT verified.
- [ ] Eight organization policies verified.
- [ ] External-IP/deny control tested.
- [ ] Organization logging sink verified.
- [ ] terraform output -json retained.
- [ ] Folder/policy/test evidence retained.
- [ ] Deployment log written.
- [ ] Evidence committed.
- [ ] README updated to deployed.
- [ ] Master validation rerun.

## 19. Cloud Detection

Candidate scenarios:
- IAM changes.
- Excessive permissions.
- Public exposure.
- Security-control changes.
- Suspicious administrative activity.
- Service-account changes.

Complete only when:
- [ ] Cloud telemetry collected.
- [ ] Detection executed.
- [ ] Expected alert defined.
- [ ] Actual alert generated.
- [ ] Investigation performed.
- [ ] Benign control tested.
- [ ] Remediation/recommendation documented.
- [ ] Verification performed.
- [ ] Evidence retained.

**Status: PENDING VALIDATION.**

## 20. IOC Investigation

Workflow:

IOC extraction -> normalization -> enrichment -> context -> confidence -> severity -> detection opportunity -> response

Complete only when:
- [ ] Safe/public/synthetic indicators.
- [ ] IOC types recorded.
- [ ] Source/context recorded.
- [ ] Enrichment performed.
- [ ] Confidence assigned.
- [ ] Severity assigned.
- [ ] Detection opportunity documented.
- [ ] Response recommendation written.
- [ ] Evidence retained.

**Status: PENDING VALIDATION.**

## 21. Controlled Phishing / Email Investigation

Workflow:

Email triage -> headers -> SPF/DKIM/DMARC -> URL/domain analysis -> IOC extraction -> risk -> containment -> awareness -> detection improvement

Required sections:
1. Executive summary
2. Scenario
3. Email metadata
4. Header analysis
5. SPF
6. DKIM
7. DMARC
8. URL/domain analysis
9. Attachment analysis where safe
10. IOC table
11. Social-engineering indicators
12. Risk assessment
13. Analyst conclusion
14. Recommended actions
15. Detection opportunities
16. User-awareness recommendations

Complete only when an authorized/synthetic case is actually analyzed and evidence is retained.

**Status: PENDING VALIDATION.**

## 22. Forage virtual experience

### Mastercard
Completed September 20, 2026:
- phishing simulation design;
- phishing campaign-results analysis and awareness training.

**Classification: VIRTUAL EXPERIENCE — NOT EMPLOYMENT.**

### Datacom
Completed September 20, 2026:
- simulated ransomware investigation;
- simulated retail risk assessment using 5x5 likelihood/consequence analysis.

**Classification: VIRTUAL EXPERIENCE — NOT EMPLOYMENT.**

## 23. Evidence directory standard

Where practical:

LAB/
├── README.md
├── data/
├── config/
├── scripts/
├── rules/
├── spl/
├── evidence/
├── screenshots/
├── reports/
└── tests/

Existing project structures remain authoritative where renaming would break evidence.

## 24. Universal QA commands

Git:
`git status`  
`git branch --show-current`  
`git log -1 --oneline`

Bash:
`bash -n path/to/script.sh`

Python:
`python3 -m py_compile path/to/file.py`  
`pytest -q`

JSON:
`python3 -m json.tool file.json`

Terraform:
`terraform fmt -check`  
`terraform init`  
`terraform validate`  
`terraform plan`

Do not claim a validation command was run unless its result is retained or otherwise verifiable.

## 25. Current portfolio-level validation

The repository's master build recorded:

**PASS=35, WARN=2, FAIL=0**

It validated repository components, 21 Bash scripts, DVWA, SIEM/Wazuh/Splunk, Network Security, Cloud Security, SOC, Security Automation, Coursework, Splunk Labs 01–06, retained builders, Splunk JSON, Dashboard Studio structure, cross-domain evidence, MITRE ATT&CK, master catalog generation and Labs 03–06 artifact validation.

Warnings:
- Nmap cross-domain path absent.
- Wireshark cross-domain path absent.

## 26. Final public COMPLETE gate

```text
[ ] Objective documented
[ ] Authorized scope documented
[ ] Environment reproducible
[ ] Tools documented
[ ] Baseline documented where applicable
[ ] Execution actually performed
[ ] Commands/queries/scripts retained
[ ] Evidence retained
[ ] Analysis performed
[ ] Timeline reconstructed where applicable
[ ] Detection logic retained where applicable
[ ] False positives considered where applicable
[ ] ATT&CK/framework mapping justified
[ ] Findings documented
[ ] Impact documented
[ ] Root cause documented
[ ] Remediation documented
[ ] Validation rerun completed
[ ] Expected vs actual recorded
[ ] Genuine screenshots only
[ ] Evidence sanitized
[ ] No secrets/private data exposed
[ ] Links validated
[ ] Code/tests/syntax validated
[ ] Report finalized
[ ] README status matches evidence
[ ] Portfolio index/evidence map updated
[ ] CI/quality checks pass
```

## 27. Current closure queue

### Documentation
- [ ] Reconcile Splunk Labs 03–06 individual README wording with track-level validation.
- [ ] Keep Lab 02 screenshot unchecked until genuinely captured.

### Indexing
- [ ] Repair Nmap cross-domain path.
- [ ] Repair Wireshark cross-domain path.
- [ ] Rerun master validation.

### Optional live expansion
- [ ] Deploy GCP Landing Zone against a real organization.
- [ ] Execute cloud-detection scenarios.
- [ ] Complete IOC enrichment case.
- [ ] Complete controlled phishing/email case.
- [ ] Add broader benign-vs-suspicious detection tests.

## 28. Recruiter evidence path

SOC Evidence Map -> Flagship SOC Investigation -> Wazuh Detection Engineering -> Azure Windows/AD -> Windows/Sysmon -> Network Security -> Security Automation

Then:

Splunk six-lab progression -> DVWA/AppSec -> Linux Hardening -> Docker Audit -> Cloud/IaC

## 29. Final principle

Real evidence over claims.  
Reproducible execution over screenshots alone.  
Context over raw severity.  
Documented limitations over exaggerated conclusions.  
Validated detections over rules that merely exist.  
Authorized telemetry over copied examples.  
Clear separation of employment, independent work, coursework and virtual experience.
