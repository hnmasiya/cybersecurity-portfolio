#!/usr/bin/env python3
"""Log Parsing and Anomaly Detection: flags brute-force bursts, off-hours logins, and privileged commands in an auth log."""
import argparse
import json
import re
from pathlib import Path

LINE_RE = re.compile(
    r'^(?P<ts>\w{3}\s+\d{1,2}\s+\d{2}:\d{2}:\d{2})\s+(?P<host>\S+)\s+(?P<proc>\S+?)(?:\[\d+\])?:\s+(?P<msg>.*)$'
)
FAILED_RE = re.compile(r'Failed password for (?:invalid user )?(?P<user>\S+) from (?P<ip>\d{1,3}(?:\.\d{1,3}){3})')
ACCEPTED_RE = re.compile(r'Accepted password for (?P<user>\S+) from (?P<ip>\d{1,3}(?:\.\d{1,3}){3})')
SUDO_MSG_RE = re.compile(r'^(?P<user>\S+)\s*:.*COMMAND=(?P<command>.+)$')

FAILED_THRESHOLD = 5
OFF_HOURS_START = 0
OFF_HOURS_END = 6


def parse_hour(ts):
    return int(ts.split()[-1].split(':')[0])


def analyze(lines):
    failed_by_ip = {}
    events = []
    total_lines = 0

    for raw in lines:
        raw = raw.rstrip('\n')
        if not raw.strip():
            continue
        m = LINE_RE.match(raw)
        if not m:
            continue
        total_lines += 1
        ts, proc, msg = m.group('ts'), m.group('proc'), m.group('msg')

        fm = FAILED_RE.search(msg)
        am = ACCEPTED_RE.search(msg)

        if fm:
            ip = fm.group('ip')
            failed_by_ip[ip] = failed_by_ip.get(ip, 0) + 1
            events.append({"timestamp": ts, "type": "failed_login", "user": fm.group('user'), "source_ip": ip})
        elif am:
            events.append({"timestamp": ts, "type": "accepted_login", "user": am.group('user'),
                            "source_ip": am.group('ip'), "hour": parse_hour(ts)})
        elif proc == 'sudo':
            sm = SUDO_MSG_RE.match(msg)
            if sm:
                events.append({"timestamp": ts, "type": "privileged_command", "user": sm.group('user'),
                                "command": sm.group('command')})

    anomalies = []

    for ip, count in failed_by_ip.items():
        if count >= FAILED_THRESHOLD:
            anomalies.append({
                "anomaly": "Brute Force Login Attempt",
                "severity": "HIGH",
                "source_ip": ip,
                "failed_attempts": count,
                "mitre_attack": {"technique": "T1110", "name": "Brute Force", "tactic": "Credential Access"},
            })

    for e in events:
        if e["type"] == "accepted_login" and OFF_HOURS_START <= e["hour"] < OFF_HOURS_END:
            anomalies.append({
                "anomaly": "Off-Hours Successful Login",
                "severity": "MEDIUM",
                "source_ip": e["source_ip"],
                "user": e["user"],
                "timestamp": e["timestamp"],
                "mitre_attack": {"technique": "T1078", "name": "Valid Accounts", "tactic": "Defense Evasion"},
            })
        if e["type"] == "privileged_command":
            anomalies.append({
                "anomaly": "Privileged Command Execution",
                "severity": "LOW",
                "user": e["user"],
                "command": e["command"],
                "timestamp": e["timestamp"],
                "mitre_attack": {"technique": "T1548", "name": "Abuse Elevation Control Mechanism", "tactic": "Privilege Escalation"},
            })

    summary = {
        "lines_parsed": total_lines,
        "anomalies_detected": len(anomalies),
        "high": sum(1 for a in anomalies if a["severity"] == "HIGH"),
        "medium": sum(1 for a in anomalies if a["severity"] == "MEDIUM"),
        "low": sum(1 for a in anomalies if a["severity"] == "LOW"),
    }
    return summary, anomalies


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--input", required=True)
    p.add_argument("--output", required=True)
    args = p.parse_args()

    lines = Path(args.input).read_text().splitlines()
    summary, anomalies = analyze(lines)

    Path(args.output).write_text(json.dumps({"summary": summary, "anomalies": anomalies}, indent=2))

    print("LOG ANOMALY DETECTION")
    print(f"Lines parsed      : {summary['lines_parsed']}")
    print(f"Anomalies detected: {summary['anomalies_detected']}")
    for a in anomalies:
        label = a.get("source_ip") or a.get("user") or ""
        print(f"{a['severity']:<6} {a['anomaly']:<32} {label}")
    print(f"HIGH:{summary['high']} MEDIUM:{summary['medium']} LOW:{summary['low']}")
    print(f"RESULT            : COMPLETE -> {args.output}")


if __name__ == "__main__":
    main()
