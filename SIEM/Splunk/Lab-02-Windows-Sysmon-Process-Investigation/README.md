# Splunk SOC Lab 02 — Windows / Sysmon Process Investigation

> **Evidence classification: Executed local training lab using synthetic telemetry.**

## Objective

Investigate Windows process creation telemetry using Sysmon-style Event ID 1 records and Splunk SPL.

The lab focuses on:

- Process creation
- Parent → child relationships
- PowerShell activity
- Command-line analysis
- Suspicious execution chains
- Timeline reconstruction
- Detection-oriented SPL
- SOC evidence and reporting

## Relationship to Splunk Lab 01

This lab builds directly on:

**Lab 01 — SSH Authentication Threat Hunting**

Lab 01 established source/account analysis, authentication correlation and timeline reconstruction.

Lab 02 extends the same methodology into endpoint telemetry:

`Authentication → Endpoint → Process → Detection → Investigation`

See:

`../Lab-01-SSH-Authentication-Hunting/README.md`

for the preceding investigation.

## Dataset

`data/sysmon_process_creation.csv`

The dataset contains synthetic Sysmon Event ID 1-style records.

## Execution status

- [x] Synthetic Sysmon dataset generated
- [x] Dedicated Splunk index configured
- [x] Dataset ingested
- [x] Process creation investigation executed
- [x] Parent/child analysis executed
- [x] PowerShell investigation executed
- [x] Suspicious command-line analysis executed
- [x] Detection-oriented SPL created
- [x] Investigation report generated
- [x] Dashboard definition generated
- [x] Dashboard REST validation attempted
- [ ] SOC monitoring dashboard screenshot captured

> The screenshot checkbox must remain unchecked until the dashboard is visually opened and genuinely captured.

## Evidence

See:

`evidence/README.md`

## Main artifacts

- `spl/process-investigation.spl`
- `spl/detection-rules.spl`
- `reports/SOC-Investigation-Report.md`
- `dashboard/SOC-Windows-Sysmon-Process-Investigation.md`
- `dashboard/dashboard-studio.json`

## Safety

No real customer, employer, credential, private infrastructure or production telemetry is used.
