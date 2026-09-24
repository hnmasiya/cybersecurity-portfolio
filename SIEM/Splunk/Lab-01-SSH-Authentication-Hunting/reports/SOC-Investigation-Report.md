# Splunk SOC Lab 01 — SSH Authentication Investigation Report

## Case / Lab ID

**SPLUNK-LAB-01 — SSH Authentication Threat Hunting**

## Evidence classification

**Executed local training lab using synthetic data.**

The investigation was performed against the synthetic `auth_events.csv` dataset in a locally authorized Splunk Enterprise 10.4.3 instance. No customer, employer, or third-party infrastructure was involved.

## Scope and data source

- Index: `splunk_lab`
- Sourcetype: `splunk:lab:ssh_auth`
- Source: `auth_events.csv`
- Host: `normann-ThinkPad-X260`
- Dataset size: **31 events**
- Event type: synthetic SSH authentication telemetry
- Time field: `timestamp`

## Investigation objective

Determine whether any source IP demonstrates authentication activity consistent with password guessing or brute-force behavior, and determine whether the same source subsequently authenticates successfully.

## Initial hypothesis

A source generating repeated SSH authentication failures against privileged accounts may warrant investigation for password guessing or credential abuse. A subsequent successful authentication from the same source increases the need for validation but does not, by itself, prove account compromise.

## SPL queries executed

### 1. Baseline

~~~spl
index=splunk_lab sourcetype="splunk:lab:ssh_auth"
~~~

### 2. Failed authentication by source

~~~spl
index=splunk_lab sourcetype="splunk:lab:ssh_auth" status=failure
| stats count by src_ip
| sort - count
~~~

### 3. Failed authentication by user

~~~spl
index=splunk_lab sourcetype="splunk:lab:ssh_auth" status=failure
| stats count by user
| sort - count
~~~

### 4. Failure/success correlation

~~~spl
index=splunk_lab sourcetype="splunk:lab:ssh_auth"
| sort 0 _time
| transaction src_ip user maxspan=5m
| search eventcount>1
| table src_ip user eventcount duration
~~~

### 5. Successful SSH logins

~~~spl
index=splunk_lab sourcetype="splunk:lab:ssh_auth" status=success
| table timestamp src_ip user host
~~~

### 6. Focused source investigation

~~~spl
index=splunk_lab sourcetype="splunk:lab:ssh_auth" src_ip=10.10.10.25
| table timestamp user status message
~~~

## Key observations

### Failed authentication volume

The failed-authentication search returned **21 failure events**.

The source with the highest failure count was:

- **10.10.10.25 — 8 failures**

Other observed failure counts:

| Source IP | Failures |
|---|---:|
| 10.10.10.25 | 8 |
| 10.10.10.45 | 4 |
| 10.10.10.47 | 3 |
| 10.10.10.41 | 2 |
| 10.10.10.43 | 1 |
| 10.10.10.44 | 1 |
| 10.10.10.49 | 1 |
| 10.10.10.51 | 1 |

### Targeted accounts

The failed-authentication search by user returned:

| User | Failures |
|---|---:|
| admin | 7 |
| root | 5 |
| dave | 4 |
| bob | 2 |
| alice | 1 |
| analyst | 1 |
| service_backup | 1 |

The primary source `10.10.10.25` targeted both `admin` and `root`.

### Focused timeline

The focused search for `10.10.10.25` returned **9 events**:

- 8 failures
- 1 success
- The failures targeted `admin` and `root`
- A successful `admin` authentication occurred at **2026-09-24T06:28:11Z**

The observed sequence contains repeated failures followed by a successful authentication from the same source and therefore warrants further investigation in a real SOC.

## Interpretation

The synthetic dataset demonstrates an authentication pattern that is **consistent with a potential password-guessing or brute-force scenario**:

~~~text
Repeated SSH failures
        ↓
Privileged accounts targeted
        ↓
Same source continues activity
        ↓
Successful authentication as admin
~~~

The dataset **does not prove account compromise**. In a real environment, the analyst would need corroborating telemetry and authorization context before classifying the activity as a confirmed incident.

## Recommended next investigative actions

1. Determine whether `10.10.10.25` is an authorized administration source.
2. Validate whether the `admin` login was expected.
3. Review Linux authentication and command-execution telemetry surrounding the successful login.
4. Review endpoint/process telemetry for post-authentication activity.
5. Check for additional authentication attempts from the same source outside the observed window.
6. Correlate with network, EDR, identity, and privileged-access telemetry where available.
7. If unauthorized access is confirmed, follow the organization's incident-response and credential-containment procedures.

## Detection engineering opportunity

A production detection could identify repeated SSH failures from one source followed by a successful login to a privileged account within a defined time window. Thresholds must be validated against organizational baselines and tuned to reduce false positives.

## MITRE ATT&CK context

The behavior is relevant to **T1110 — Brute Force** when the underlying activity is confirmed as password guessing or credential attack behavior. The synthetic lab demonstrates the investigative pattern; it does not independently establish that a real ATT&CK technique occurred.

## Evidence limitations

- Synthetic dataset only.
- No real endpoint or identity telemetry.
- No proof of authorization state for the synthetic source IPs.
- No post-authentication command telemetry.
- Findings are intentionally limited to what the dataset supports.

## Evidence captured

The following screenshots document the executed investigation:

- Field extraction / 31-event validation
- Failed authentication by source
- Failed authentication by user
- Failure/success correlation
- Successful SSH logins
- Focused investigation of `10.10.10.25`

A dashboard screenshot should be added after the SOC monitoring dashboard is created.

## Lab conclusion

**Investigation executed successfully.**

The lab demonstrates ingestion, structured CSV parsing, field extraction, SPL-based authentication hunting, source/account analysis, timeline reconstruction, and analyst interpretation using synthetic SSH telemetry.
