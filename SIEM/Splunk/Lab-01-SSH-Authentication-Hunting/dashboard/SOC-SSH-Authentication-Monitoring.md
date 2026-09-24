# Splunk SOC Lab 01 — SSH Authentication Monitoring Dashboard

## Purpose

Create a compact SOC-style dashboard for the executed synthetic SSH authentication lab.

Dashboard name:

**SOC — SSH Authentication Monitoring**

Use the existing `splunk_lab` index and `splunk:lab:ssh_auth` sourcetype.

## Panel 1 — Total authentication events

~~~spl
index=splunk_lab sourcetype="splunk:lab:ssh_auth"
| stats count as total_events
~~~

Visualization: Single Value.

## Panel 2 — Failed vs successful authentication

~~~spl
index=splunk_lab sourcetype="splunk:lab:ssh_auth"
| stats count(eval(status="failure")) as failures count(eval(status="success")) as successes
~~~

Visualization: Column chart or Single Value pair.

## Panel 3 — Failed authentication by source

~~~spl
index=splunk_lab sourcetype="splunk:lab:ssh_auth" status=failure
| stats count as failures by src_ip
| sort - failures
~~~

Visualization: Bar chart.

## Panel 4 — Failed authentication by account

~~~spl
index=splunk_lab sourcetype="splunk:lab:ssh_auth" status=failure
| stats count as failures by user
| sort - failures
~~~

Visualization: Bar chart.

## Panel 5 — Authentication activity over time

~~~spl
index=splunk_lab sourcetype="splunk:lab:ssh_auth"
| timechart span=1m count by status
~~~

Visualization: Line/column chart.

## Panel 6 — Suspicious source candidates

~~~spl
index=splunk_lab sourcetype="splunk:lab:ssh_auth"
| stats count as events count(eval(status="failure")) as failures count(eval(status="success")) as successes values(user) as targeted_users by src_ip
| eval failure_rate=round((failures/events)*100,2)
| where failures >= 5
| sort - failures
~~~

Visualization: Table.

> The five-failure threshold is a laboratory heuristic, not a production detection threshold.

## Panel 7 — Failure followed by successful authentication

~~~spl
index=splunk_lab sourcetype="splunk:lab:ssh_auth"
| sort 0 _time
| transaction src_ip user maxspan=5m
| search eventcount>1
| table src_ip user eventcount duration
| sort - eventcount
~~~

Visualization: Table.

## Panel 8 — Focused source timeline

~~~spl
index=splunk_lab sourcetype="splunk:lab:ssh_auth" src_ip=10.10.10.25
| sort 0 _time
| table timestamp src_ip user action service status message
~~~

Visualization: Table.

## Dashboard evidence requirement

Capture one screenshot showing the completed dashboard with the panel titles and representative results visible.

Save it as:

`evidence/07-soc-ssh-authentication-dashboard.png`

Do not include passwords, tokens, session cookies, or unrelated private data in the screenshot.
