# Splunk Lab 01 — Dashboard Execution Validation

## Execution classification

**Executed local training lab using synthetic SSH authentication telemetry.**

Splunk Enterprise 10.4.3 was run in an authorized local environment. The dashboard and searches use the dedicated `splunk_lab` index and `splunk:lab:ssh_auth` sourcetype.

## Dataset validation

| Metric | Observed |
|---|---:|
| Total authentication events | 31 |
| Failed authentication events | 21 |
| Successful authentication events | 10 |

## Dashboard validation

| Component | Observed |
|---|---:|
| Dashboard | SOC SSH Authentication Monitoring |
| Visualizations | 7 |
| Data sources | 7 |
| Tabs | 1 — SOC Overview |
| Layout panels | 7 |
| Unresolved token references | 0 |
| Invalid `legendDisplay` options | 0 |
| REST update | HTTP 200 |
| Final Dashboard Studio definition | Valid |

## Final panels

1. Total Authentication Events
2. Failed vs Successful Authentication
3. Top Failed Source IPs
4. Top Targeted Accounts
5. Authentication Timeline
6. Suspicious Sources / High-Failure Sources
7. Source / User Authentication Investigation

## Observed investigation anchors

- `10.10.10.25` produced 8 failed authentication events.
- The focused source contained 9 events: 8 failures and 1 successful authentication.
- The successful authentication was for `admin`.
- `admin` was the most frequently failed target account overall with 7 failures.

## Evidence limitations

The telemetry is synthetic. The observed sequence is suitable for SOC training and investigation practice, but it does not establish a real compromise or a real-world incident.

The dashboard screenshot was captured during local execution and should be retained as a sanitized visual artifact if binary evidence is added to the repository later. No credentials, tokens, cookies, customer data, or private infrastructure information should be committed.

## Reproducibility

The dashboard SPL is documented in:

`dashboard/SOC-SSH-Authentication-Monitoring.md`

The broader investigation report is documented in:

`reports/SOC-Investigation-Report.md`
