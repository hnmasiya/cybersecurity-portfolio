# Splunk SOC Lab 01 — SSH Authentication Threat Hunting

> **Evidence classification: Executed local training lab using synthetic data**
>
> Lab 01 has now been executed in an authorized local Splunk Enterprise 10.4.3 instance. The dataset is synthetic and safe for training. The results document the observed synthetic telemetry only and must not be represented as real customer or employer telemetry.

## Objective

Use Splunk Search Processing Language (SPL) to investigate SSH authentication activity, identify suspicious authentication patterns, reconstruct a timeline, and document a defensible SOC finding.

## Scenario

The dataset represents SSH authentication activity against a Linux server.

The investigation should determine whether any source IP demonstrates a pattern consistent with password guessing or possible credential compromise.

The dataset deliberately contains both ordinary authentication activity and suspicious-looking sequences so that the analyst must separate signal from normal behavior.

## Dataset

File:

`data/auth_events.csv`

Important fields:

| Field | Meaning |
|---|---|
| `timestamp` | Event time in UTC |
| `sourcetype` | Synthetic Splunk sourcetype |
| `host` | Lab host |
| `event_type` | Event category |
| `src_ip` | Source address |
| `user` | Target account |
| `action` | Authentication action |
| `service` | Service |
| `status` | `success` or `failure` |
| `process` | Process that recorded the event |
| `message` | Human-readable event description |

## Safe lab setup

1. Start a Splunk instance that you are authorized to use.
2. Add `data/auth_events.csv` as a CSV data source.
3. Use the `timestamp` field as the event-time field during data preview if Splunk asks for timestamp extraction.
4. Use the synthetic sourcetype value already present in the data.
5. Send the data to a dedicated lab index, preferably a non-production index such as `splunk_lab`.
6. Confirm that events are searchable before continuing.
7. For the portfolio execution, use the dedicated `splunk_lab` index and custom `splunk:lab:ssh_auth` sourcetype.

> Do not upload real customer, employer, credential, or private infrastructure data into this training dataset.

## Search sequence

Begin with the broad dataset:

```spl
index=splunk_lab sourcetype="splunk:lab:ssh_auth"
```

Then inspect failures:

```spl
index=splunk_lab sourcetype="splunk:lab:ssh_auth" status=failure
| stats count as failures by src_ip
| sort - failures
```

Break failures down by target account:

```spl
index=splunk_lab sourcetype="splunk:lab:ssh_auth" status=failure
| stats count as failures by src_ip user
| sort - failures
```

Compare success and failure activity:

```spl
index=splunk_lab sourcetype="splunk:lab:ssh_auth"
| stats count as events count(eval(status="failure")) as failures count(eval(status="success")) as successes by src_ip
| eval failure_rate=round((failures/events)*100,2)
| sort - failures
```

Inspect the key source candidate:

```spl
index=splunk_lab sourcetype="splunk:lab:ssh_auth" src_ip=10.10.10.25
| sort 0 timestamp
| table timestamp src_ip user action service status message
```

Build a timeline by source:

```spl
index=splunk_lab sourcetype="splunk:lab:ssh_auth"
| stats earliest(timestamp) as first_seen latest(timestamp) as last_seen count as events count(eval(status="failure")) as failures count(eval(status="success")) as successes values(user) as targeted_users by src_ip
| eval duration=tostring(last_seen-first_seen,"duration")
| sort - failures
```

Visualize authentication activity:

```spl
index=splunk_lab sourcetype="splunk:lab:ssh_auth"
| timechart span=1m count by status
```

## Investigation questions

Do not read an answer key first. Use the SPL results to answer:

1. Which source IP generated the highest number of authentication failures?
2. Which accounts were targeted by that source?
3. Did the source later authenticate successfully?
4. What is the elapsed time between the first suspicious failure sequence and the successful login?
5. Does the dataset prove account compromise, or does it only provide an indicator requiring further investigation?
6. Which additional telemetry would you request in a real SOC?
7. What containment or validation action would be appropriate before treating the event as a confirmed incident?

## Analyst output

Complete a short investigation note containing:

- Case / lab ID
- Scope and data source
- Initial hypothesis
- SPL queries used
- Key observations
- Timeline
- Suspicious source(s)
- Targeted account(s)
- Interpretation
- Evidence limitations
- Recommended next investigative step
- MITRE ATT&CK mapping where justified

## Execution status

**Investigation execution: complete. SOC dashboard execution: complete.**

Observed execution results:

- 31 synthetic events indexed successfully.
- 21 failure events identified.
- 10 successful authentication events identified.
- `10.10.10.25` generated the highest failure count with 8 failures.
- `admin` was the most frequently failed target account with 7 failures overall.
- The focused `10.10.10.25` timeline contained 9 events: 8 failures and 1 successful `admin` authentication.

### Completion criteria

- [x] Dataset successfully ingested into Splunk
- [x] Base search executed
- [x] Failure aggregation executed
- [x] Source/account analysis executed
- [x] Timeline search executed
- [x] At least one visualization or table captured
- [x] Analyst findings written from observed results
- [x] Screenshots or sanitized exported evidence retained
- [x] Evidence is traceable to this lab execution
- [x] SOC monitoring dashboard executed and validated
- [x] SOC monitoring dashboard screenshot captured
- [x] Dashboard structure validated: 7 visualizations, 7 data sources, 1 tab, 7 layout panels
- [x] Dashboard data validated: 31 total events, 21 failures, 10 successes
- [x] Dashboard schema/token validation completed with zero unresolved token references

See `reports/SOC-Investigation-Report.md` for the investigation narrative and `dashboard/SOC-SSH-Authentication-Monitoring.md` for the executed dashboard specification and validation record.

## Evidence directory

Use:

`evidence/`

for sanitized screenshots, exported result tables, and the final investigation note.

Do not place passwords, tokens, session cookies, private IP inventories, customer data, or other sensitive material in the repository.

## Next lab

After this lab is executed and documented, the Splunk track will continue into:

**Lab 02 — Windows / Sysmon Event Investigation**

That lab will focus on process creation, PowerShell activity, parent-child relationships, and detection-oriented SPL.
