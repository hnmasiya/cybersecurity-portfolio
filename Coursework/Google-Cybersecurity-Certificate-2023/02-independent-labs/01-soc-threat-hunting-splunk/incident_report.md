# SOC Incident Report: SSH Authentication Investigation

**Investigator:** Hazvinei Nomatter Masiya  
**Date:** August 22, 2026  
**Severity:** Medium  
**Status:** Investigated  
**Classification:** Potential credential-guessing / credential-compromise indicator  
**Environment:** Independent security lab

## 1. Executive Summary

Analysis of a controlled SSH authentication dataset identified a suspicious authentication sequence originating from `192.168.1.105`.

The source generated two failed authentication attempts against `root` and `admin` within four seconds and subsequently authenticated successfully to the `admin` account 536 seconds after the latest failed attempt.

This sequence is consistent with a potential credential-guessing or credential-compromise indicator.

The available evidence is insufficient to confirm a brute-force attack or account compromise. Additional authentication, endpoint, network, and session telemetry would be required for confirmation.

## 2. Scope

The investigation was limited to the supplied `auth_logs.json` dataset.

The following fields were analyzed:

- Timestamp
- Source IP
- Username
- Authentication result
- Service

No production systems were accessed or modified as part of this investigation.

## 3. Evidence Reviewed

| Evidence | Purpose |
|---|---|
| `auth_logs.json` | Authentication event dataset |
| `analyze_auth_logs.py` | Reproducible analysis |
| SPL examples | Detection-engineering demonstration |

## 4. Authentication Timeline

| Timestamp (UTC) | Source IP | User | Action | Service |
|---|---|---|---|---|
| 02:14:01 | 192.168.1.105 | root | Failed | SSH |
| 02:14:05 | 192.168.1.105 | admin | Failed | SSH |
| 02:23:01 | 192.168.1.105 | admin | Success | SSH |

### Calculated intervals

- Failed attempt 1 → failed attempt 2: **4 seconds**
- Failed attempt 2 → successful authentication: **536 seconds**
- Failed attempt 1 → successful authentication: **540 seconds**

## 5. Investigation Findings

### Finding 1 — Multiple account targets

The source attempted authentication against both `root` and `admin`.

This demonstrates targeting of more than one account but does not independently establish malicious intent.

### Finding 2 — Rapid failed-authentication sequence

The two failed authentication events occurred four seconds apart.

This represents a short authentication-failure sequence that warrants investigation when observed against an administrative service.

### Finding 3 — Subsequent successful authentication

The same source subsequently authenticated successfully to `admin`.

The successful event occurred 536 seconds after the latest failed attempt.

This failed → successful sequence is the primary detection signal.

### Finding 4 — Evidence limitations

Only three authentication events are available.

The dataset cannot establish:

- Total authentication attempts
- Whether the source continued activity before or after the observed events
- Whether the successful authentication was legitimate
- Whether commands were executed
- Whether persistence was established
- Whether lateral movement occurred
- Whether data was accessed or exfiltrated

## 6. Analyst Assessment

**Assessment: Potential credential-guessing or credential-compromise indicator.**

The evidence warrants additional investigation but does not justify classifying the event as a confirmed compromise.

The successful authentication is particularly important because it changes the investigative priority from simply reviewing failed login attempts to determining whether the authenticated session was authorized.

## 7. Detection Engineering

### Failed authentication detection

```spl
index=security_logs sourcetype="auth_logs" action="failed"
| stats count BY src_ip, user
| sort - count

```
