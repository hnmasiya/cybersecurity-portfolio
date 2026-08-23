#!/usr/bin/env python3
"""Active Directory Security Event Analyzer.

Analyzes a batch of Windows Security event log records for common Active
Directory attack and abuse patterns, and maps findings to MITRE ATT&CK.
Offline/synthetic validation only.
"""
import argparse
import json
from collections import Counter, defaultdict
from pathlib import Path

BRUTE_FORCE_THRESHOLD = 5
KERBEROASTING_THRESHOLD = 3
PREAUTH_FAILURE_THRESHOLD = 5
RC4_ENCRYPTION_TYPE = "0x17"

PRIVILEGED_GROUP_EVENT_IDS = {4728, 4732, 4756}


def analyze(events):
    findings = []

    failed_logons_by_user = Counter(
        e.get("target_user") for e in events if e.get("event_id") == 4625
    )
    for user, count in failed_logons_by_user.items():
        if count >= BRUTE_FORCE_THRESHOLD:
            findings.append({
                "finding": "Brute Force Authentication Attempt",
                "severity": "HIGH",
                "target_user": user,
                "failed_attempts": count,
                "mitre_attack": {"technique": "T1110", "name": "Brute Force", "tactic": "Credential Access"},
            })

    preauth_failures_by_user = Counter(
        e.get("target_user") for e in events if e.get("event_id") == 4771
    )
    for user, count in preauth_failures_by_user.items():
        if count >= PREAUTH_FAILURE_THRESHOLD:
            findings.append({
                "finding": "Kerberos Pre-Authentication Failure Burst",
                "severity": "HIGH",
                "target_user": user,
                "failure_count": count,
                "mitre_attack": {"technique": "T1110", "name": "Brute Force", "tactic": "Credential Access"},
            })

    tgs_services_by_user = defaultdict(set)
    rc4_tgs_count_by_user = defaultdict(int)
    for e in events:
        if e.get("event_id") == 4769:
            user = e.get("target_user")
            tgs_services_by_user[user].add(e.get("service_name"))
            if e.get("encryption_type") == RC4_ENCRYPTION_TYPE:
                rc4_tgs_count_by_user[user] += 1

    for user, services in tgs_services_by_user.items():
        if len(services) >= KERBEROASTING_THRESHOLD and rc4_tgs_count_by_user.get(user, 0) >= KERBEROASTING_THRESHOLD:
            findings.append({
                "finding": "Possible Kerberoasting Activity",
                "severity": "HIGH",
                "target_user": user,
                "distinct_service_tickets": len(services),
                "rc4_ticket_requests": rc4_tgs_count_by_user[user],
                "mitre_attack": {"technique": "T1558.003", "name": "Kerberoasting", "tactic": "Credential Access"},
            })

    for e in events:
        event_id = e.get("event_id")

        if event_id in PRIVILEGED_GROUP_EVENT_IDS:
            findings.append({
                "finding": "Privileged Group Membership Change",
                "severity": "HIGH",
                "target_user": e.get("target_user"),
                "group": e.get("group_name"),
                "actor": e.get("subject_user"),
                "timestamp": e.get("timestamp"),
                "mitre_attack": {"technique": "T1098", "name": "Account Manipulation", "tactic": "Persistence"},
            })

        elif event_id == 4720:
            findings.append({
                "finding": "New User Account Created",
                "severity": "MEDIUM",
                "target_user": e.get("target_user"),
                "actor": e.get("subject_user"),
                "timestamp": e.get("timestamp"),
                "mitre_attack": {"technique": "T1136", "name": "Create Account", "tactic": "Persistence"},
            })

        elif event_id == 4672:
            findings.append({
                "finding": "Special Privileges Assigned to New Logon",
                "severity": "MEDIUM",
                "target_user": e.get("target_user"),
                "timestamp": e.get("timestamp"),
                "mitre_attack": {"technique": "T1078", "name": "Valid Accounts", "tactic": "Privilege Escalation"},
            })

        elif event_id == 1102:
            findings.append({
                "finding": "Security Audit Log Cleared",
                "severity": "CRITICAL",
                "actor": e.get("subject_user"),
                "timestamp": e.get("timestamp"),
                "mitre_attack": {"technique": "T1070.001", "name": "Clear Windows Event Logs", "tactic": "Defense Evasion"},
            })

    summary = {
        "events_analyzed": len(events),
        "findings": len(findings),
        "critical": sum(1 for f in findings if f["severity"] == "CRITICAL"),
        "high": sum(1 for f in findings if f["severity"] == "HIGH"),
        "medium": sum(1 for f in findings if f["severity"] == "MEDIUM"),
    }
    return summary, findings


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--input", required=True)
    p.add_argument("--output", required=True)
    args = p.parse_args()

    events = json.loads(Path(args.input).read_text())
    summary, findings = analyze(events)

    Path(args.output).write_text(json.dumps({"summary": summary, "findings": findings}, indent=2) + "\n")

    print("ACTIVE DIRECTORY SECURITY EVENT ANALYZER")
    print("=" * 60)
    print(f"Events analyzed : {summary['events_analyzed']}")
    print(f"Findings        : {summary['findings']}")
    for f in findings:
        label = f.get("target_user") or f.get("actor") or ""
        print(f"{f['severity']:<8} {f['finding']:<38} {label}")
    print(f"CRITICAL:{summary['critical']} HIGH:{summary['high']} MEDIUM:{summary['medium']}")
    print(f"RESULT          : COMPLETE -> {args.output}")


if __name__ == "__main__":
    main()
