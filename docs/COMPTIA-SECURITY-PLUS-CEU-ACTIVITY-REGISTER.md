# CompTIA Security+ CEU Activity Register
## Renewal cycle: 31 July 2026 – 30 July 2029

**Candidate:** Hazvinei Nomatter Masiya  
**Certification:** CompTIA Security+ (SY0-701)  
**Portfolio:** https://github.com/hnmasiya/cybersecurity-portfolio  
**Supporting guide:** [CEU Portfolio Documentation](COMPTIA-SECURITY-PLUS-CEU-PORTFOLIO.md)  
**Register status:** Initial evidence inventory — not a CompTIA-approved CEU submission  
**Prepared:** 14 October 2026

> **Important:** This register does not claim any CEUs or assert that independent lab projects qualify. The renewal window supplied by the candidate is 31 July 2026 through 30 July 2029. Only activity occurring within that window is potentially relevant to this register. GitHub commit dates prove repository changes, not the time spent learning or performing the activity. No hours have been estimated or inferred.

## Status definitions

- **Candidate activity:** Portfolio indicates a related workstream exists; individual activity, date, and supporting evidence still need verification.
- **Evidence to collect:** Add direct links to the exact report, scripts, screenshots, notes, tests, and relevant commit.
- **Incomplete / rework required:** Do not represent as completed until the relevant steps and validation are finished.
- **Eligibility unconfirmed:** Check the current CompTIA CE program rules for an eligible category before submitting.
- **Hours not recorded:** Enter only actual time supported by contemporaneous notes or time records.

## A. Candidate activity register

The entries below are a **triage list**, not verified claims that every activity was completed during this renewal cycle. Verify the exact date of each discrete activity, the work personally performed, and its supporting artifacts before changing its status.

| ID | Candidate activity | Current evidence pointer | Activity date within cycle | Actual time | Status / next action |
|---|---|---|---|---|---|
| CEU-001 | Splunk SOC lab: authentication-event hunting | [Splunk lab directory](https://github.com/hnmasiya/cybersecurity-portfolio/tree/main/SIEM/Splunk/) | Not yet verified | Not recorded | Candidate activity. Attach the specific lab report, query, sanitized output/screenshots, notes and actual time record. Eligibility unconfirmed. |
| CEU-002 | Splunk SOC lab: Windows/Sysmon endpoint investigation | [Splunk lab directory](https://github.com/hnmasiya/cybersecurity-portfolio/tree/main/SIEM/Splunk/) | Not yet verified | Not recorded | Candidate activity. Verify exact lab status and telemetry; distinguish synthetic data from live lab telemetry. |
| CEU-003 | Splunk SOC lab: HTTP/web access-log investigation | [Splunk lab directory](https://github.com/hnmasiya/cybersecurity-portfolio/tree/main/SIEM/Splunk/) | Not yet verified | Not recorded | **Incomplete/rework may apply:** prior notes indicate the lab needed correction to use `http_access_events.csv` instead of a missing `web_attack_http_events.csv`. Verify current files and rerun results before claiming completion. |
| CEU-004 | Splunk detection engineering with SPL | [Splunk lab directory](https://github.com/hnmasiya/cybersecurity-portfolio/tree/main/SIEM/Splunk/) | Not yet verified | Not recorded | Candidate activity. Attach SPL detection, test cases, observed results, limitations and actual time record. |
| CEU-005 | Splunk SOC monitoring/dashboard work | [Splunk lab directory](https://github.com/hnmasiya/cybersecurity-portfolio/tree/main/SIEM/Splunk/) | Not yet verified | Not recorded | Candidate activity. Verify dashboard and data sources exist; attach screenshots and validation notes. |
| CEU-006 | End-to-end SOC investigation / case workflow | [Splunk lab directory](https://github.com/hnmasiya/cybersecurity-portfolio/tree/main/SIEM/Splunk/) | Not yet verified | Not recorded | Candidate activity. Attach case timeline, queries, findings, conclusion and validation evidence. |
| CEU-007 | Wazuh SIEM custom detection / file-integrity monitoring | [Wazuh lab directory](https://github.com/hnmasiya/cybersecurity-portfolio/tree/main/SIEM/Wazuh/) · [Wazuh detection lab repository](https://github.com/hnmasiya/wazuh-siem-detection-lab) | Not yet verified | Not recorded | Candidate activity. Verify rule tests, alerts, configuration, screenshots and live/offline validation status. |
| CEU-008 | Windows/Sysmon endpoint detection | [Windows/Sysmon lab](https://github.com/hnmasiya/cybersecurity-portfolio/tree/main/Endpoint-Security/Windows-Sysmon-Detection-Lab/) | Not yet verified | Not recorded | Candidate activity. Attach event IDs, event examples, detection logic and validation outcome. |
| CEU-009 | Active Directory security-event parsing | [AD log parser](https://github.com/hnmasiya/ad-security-log-parser) | Not yet verified | Not recorded | Candidate activity. Attach source code, test inputs, output, test results and explanation of events such as 4624/4625/4728 only where actually analysed. |
| CEU-010 | Linux digital forensics / evidence integrity | [DFIR directory](https://github.com/hnmasiya/cybersecurity-portfolio/tree/main/DFIR/) | Not yet verified | Not recorded | Candidate activity. Verify exact completed exercise and attach sanitized findings, hashes, and evidence-handling notes. |
| CEU-011 | Network traffic / PCAP analysis | [Network Security directory](https://github.com/hnmasiya/cybersecurity-portfolio/tree/main/Network-Security/) | Not yet verified | Not recorded | Candidate activity. Attach the PCAP or safe sample reference, queries/commands, findings and validation notes. |
| CEU-012 | GCP secure VPC / Terraform controls | [GCP Terraform secure VPC](https://github.com/hnmasiya/gcp-terraform-secure-vpc) | Not yet verified | Not recorded | Candidate activity. Distinguish deployed/tested controls from code or architecture-only work; attach plan/apply/test evidence where applicable. |
| CEU-013 | Authorized web-application security lab | [Web Security directory](https://github.com/hnmasiya/cybersecurity-portfolio/tree/main/Web-Security/) | Not yet verified | Not recorded | Candidate activity. Verify authorized lab scope, completed tests, findings and remediation/validation. |
| CEU-014 | Security automation / analysis scripts | [Security Automation directory](https://github.com/hnmasiya/cybersecurity-portfolio/tree/main/Security-Automation/) | Not yet verified | Not recorded | Candidate activity. Identify the specific script and learning activity; attach tests, sample input/output and notes. |

### Register interpretation

1. The rows are workstreams to investigate, not 14 confirmed qualifying activities.
2. Do not sum time across overlapping work or count the same learning activity twice.
3. Split a project into separate entries only when there were distinct learning activities with separately documented dates, work, and evidence.
4. A commit, README, screenshot, or lab file alone does not establish the number of hours spent.
5. Do not include an activity in a CEU claim until both the activity details and eligibility under the current CompTIA rules are verified.

## B. Activity evidence worksheet

Duplicate for each discrete activity that has been verified as occurring during the renewal cycle.

### [ID] — [Activity title]

- **Activity date(s):** [YYYY-MM-DD; include each session if needed]
- **Within cycle (31 July 2026–30 July 2029):** [Yes / No / Needs verification]
- **Actual time spent:** [Leave blank until supported by time records]
- **Time-record source:** [Dated notes, timesheet, session log, etc.]
- **Portfolio path:** [Direct URL]
- **Commit / release:** [Direct URL or SHA, if applicable]
- **Environment:** [Local VM / lab / cloud sandbox / offline analysis]
- **Data type:** [Synthetic / authorized telemetry / offline / other]
- **Completion state:** [Completed / partial / rework required]
- **CompTIA activity category:** [Unconfirmed until checked against current official rules]
- **Security+ objective mapping:** [Exact objective code and wording from current official objectives]

**Objective and scope:**  
[What security question was investigated?]

**Work personally performed:**  
[Concrete steps performed, tools used, queries or scripts written, and configuration changed.]

**Evidence retained:**  
[Exact links to sanitized screenshots, scripts, logs, test results, reports, and dated notes.]

**Result and validation:**  
[Observed results and the method used to validate them.]

**Learning reflection:**  
[What was learned and how it relates to Security+ knowledge.]

**Limitations / unsuccessful attempts:**  
[Missing telemetry, synthetic data, failed tests, assumptions, incomplete work.]

**Eligibility check:**  
[Official CompTIA rule/category checked, date checked, and outcome; do not imply approval.]

**Reviewer decision:** [Pending / eligible to consider / not eligible / ask CompTIA]

## C. Time-record standard

Use contemporaneous notes or a time record. If time was not recorded, reconstruct it only where reliable supporting records exist, label it as reconstructed, explain the basis, and follow the rules for the relevant CompTIA category. If the time cannot be substantiated, leave it blank. Do not convert GitHub commit timestamps into hours.

Suggested fields for a separate session log:

| Date | Activity ID | Start/end or duration | Task performed | Evidence created | Source of time record |
|---|---|---|---|---|---|
| [YYYY-MM-DD] | [ID] | [Actual recorded duration] | [Specific task] | [URL/file] | [Dated note / timer / timesheet] |

## D. Review checklist before a CE submission

- [ ] Confirm the candidate's renewal-cycle dates in the CompTIA account.
- [ ] Confirm every claimed activity occurred from 31 July 2026 through 30 July 2029.
- [ ] Check current official CompTIA CE rules and category-specific evidence requirements.
- [ ] Confirm whether the specific independent activity is accepted under an eligible category.
- [ ] Use exact current Security+ objective codes and wording, not an assumed mapping.
- [ ] Attach direct links to work and sanitized supporting evidence.
- [ ] Record only supported actual time where the selected category permits/requires it.
- [ ] Identify synthetic data, offline validation, failed tests, and incomplete work.
- [ ] Remove secrets, customer/employer data, and personal information.
- [ ] Do not claim a CEU amount or approval until the rules and CompTIA decision support it.

## Official references

- [CompTIA — Earn Continuing Education Units](https://www.comptia.org/continuing-education/learn/earn-continuing-education-units)
- [CompTIA Continuing Education program](https://www.comptia.org/continuing-education)

**Prepared by:** Hazvinei Nomatter Masiya  
**Last updated:** 2026-10-14  
**Status:** Evidence inventory in progress; no CEUs claimed.
