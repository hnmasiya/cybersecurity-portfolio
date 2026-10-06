# SOC Threat Hunting & Incident Investigation

## Objective

Investigate SSH authentication activity using a structured SOC workflow, identify suspicious authentication behavior, reconstruct the event timeline, assess potential security impact, and execute automated IP containment and enforce mandatory password resets across affected user accounts.

## Scenario

This independent lab analyzes a small authentication dataset representing SSH activity from a single source IP.

The investigation focuses on a sequence in which:

1. The source attempts authentication against two accounts.
2. Both authentication attempts fail.
3. The same source subsequently authenticates successfully to the `admin` account.

The activity is assessed as a **potential credential-guessing or credential-compromise indicator**, not as a confirmed compromise.

## Evidence

| Artifact | Purpose |
|---|---|
| `auth_logs.json` | Source authentication events |
| `analyze_auth_logs.py` | Reproducible authentication-log analysis |
| `incident_report.md` | Structured investigation report, findings, and response recommendations |

## Observed Activity

The supplied dataset contains three SSH authentication events from `192.168.1.105`.

| Timestamp (UTC) | Source IP | User | Action | Service |
|---|---|---|---|---|
| 02:14:01 | 192.168.1.105 | root | Failed | SSH |
| 02:14:05 | 192.168.1.105 | admin | Failed | SSH |
| 02:23:01 | 192.168.1.105 | admin | Successful | SSH |

The two failed authentication attempts occurred **4 seconds apart**. The successful `admin` authentication occurred **536 seconds (8 minutes 56 seconds)** after the latest failed attempt.

All three events originated from the same source IP.

## Investigation Methodology

1. Parse authentication events.
2. Normalize and order events chronologically.
3. Group failed authentication activity by source IP.
4. Identify accounts targeted by the source.
5. Identify successful authentication following failed activity.
6. Calculate the time relationship between failed and successful events.
7. Assess whether the sequence represents a potential security concern.
8. Document evidence, limitations, and response recommendations.

## Reproducible Analysis

The included Python analyzer reproduces the timeline and identifies the failed-to-successful authentication relationship.

Run:

```bash
python3 analyze_auth_logs.py

```
