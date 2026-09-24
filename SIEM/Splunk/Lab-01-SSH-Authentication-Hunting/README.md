# Splunk SOC Lab 01 — SSH Authentication Threat Hunting

> **Evidence classification: Synthetic / offline preparation**
>
> This lab is the first hands-on Splunk lab added to the portfolio track. The dataset is synthetic and safe for training. It is **not** live Splunk telemetry and must not be described as live evidence until the searches are actually executed in a Splunk environment.

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

## Completion criteria

This lab becomes **completed evidence** only after all of the following exist:

- [ ] Dataset successfully ingested into Splunk
- [ ] Base search executed
- [ ] Failure aggregation executed
- [ ] Source/account analysis executed
- [ ] Timeline search executed
- [ ] At least one visualization or table captured
- [ ] Analyst findings written from observed results
- [ ] Screenshots or sanitized exported evidence retained
- [ ] Evidence is dated and traceable to this lab
- [ ] Portfolio status updated from preparation/in-progress only after execution

## Evidence directory

Use:

`evidence/`

for sanitized screenshots, exported result tables, and the final investigation note.

Do not place passwords, tokens, session cookies, private IP inventories, customer data, or other sensitive material in the repository.

## Next lab

After this lab is executed and documented, the Splunk track will continue into:

**Lab 02 — Windows / Sysmon Event Investigation**

That lab will focus on process creation, PowerShell activity, parent-child relationships, and detection-oriented SPL.
