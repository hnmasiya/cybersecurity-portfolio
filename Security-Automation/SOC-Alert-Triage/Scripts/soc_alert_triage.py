#!/usr/bin/env python3
"""SOC Alert Triage and IOC Enrichment: extracts IOCs, maps MITRE ATT&CK, assigns priority/disposition."""
import argparse
import json
import re
from pathlib import Path

IPV4_RE = re.compile(r'\b(?:\d{1,3}\.){3}\d{1,3}\b')
SHA256_RE = re.compile(r'\b[a-fA-F0-9]{64}\b')
DOMAIN_RE = re.compile(r'\b(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,63}\b')

SEVERITY_PRIORITY = {"CRITICAL": "P1", "HIGH": "P2", "MEDIUM": "P3", "LOW": "P4"}
DISPOSITION = {"CRITICAL": "ESCALATE", "HIGH": "ESCALATE", "MEDIUM": "INVESTIGATE", "LOW": "MONITOR"}

MITRE_KEYWORDS = [
    ("brute force", "T1110", "Brute Force", "Credential Access"),
    ("powershell", "T1059.001", "PowerShell", "Execution"),
    ("data manipulation", "T1565", "Data Manipulation", "Impact"),
    ("phishing", "T1566", "Phishing", "Initial Access"),
    ("sql injection", "T1190", "Exploit Public-Facing Application", "Initial Access"),
    ("privilege escalation", "T1068", "Exploitation for Privilege Escalation", "Privilege Escalation"),
    ("lateral movement", "T1021", "Remote Services", "Lateral Movement"),
    ("exfiltration", "T1041", "Exfiltration Over C2 Channel", "Exfiltration"),
    ("command and control", "T1071", "Application Layer Protocol", "Command and Control"),
    ("port scan", "T1595", "Active Scanning", "Reconnaissance"),
    ("malware", "T1204", "User Execution", "Execution"),
]


def extract_iocs(text):
    return {
        "ipv4": sorted(set(IPV4_RE.findall(text))),
        "domains": sorted(set(d for d in DOMAIN_RE.findall(text) if not IPV4_RE.fullmatch(d))),
        "sha256": sorted(set(SHA256_RE.findall(text))),
    }


def map_mitre(text):
    t = text.lower()
    return [{"technique": tech, "name": name, "tactic": tactic}
            for kw, tech, name, tactic in MITRE_KEYWORDS if kw in t]


def triage_alert(alert):
    description = alert.get("description", "")
    severity = str(alert.get("severity", "MEDIUM")).upper()
    if severity not in SEVERITY_PRIORITY:
        severity = "MEDIUM"
    return {
        "alert_id": alert.get("alert_id", "UNKNOWN"),
        "timestamp": alert.get("timestamp", ""),
        "source": alert.get("source", ""),
        "severity": severity,
        "priority": SEVERITY_PRIORITY[severity],
        "disposition": DISPOSITION[severity],
        "iocs": extract_iocs(description),
        "mitre_attack": map_mitre(description),
        "description": description,
    }


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--input", required=True)
    p.add_argument("--output", required=True)
    args = p.parse_args()

    alerts = json.loads(Path(args.input).read_text())
    results = [triage_alert(a) for a in alerts]

    summary = {"total": len(results)}
    for k in ("ESCALATE", "INVESTIGATE", "MONITOR"):
        summary[k.lower()] = sum(1 for r in results if r["disposition"] == k)

    Path(args.output).write_text(json.dumps({"summary": summary, "alerts": results}, indent=2))

    print("SOC ALERT TRIAGE")
    print(f"Alerts processed : {summary['total']}")
    for r in results:
        ioc_count = sum(len(v) for v in r["iocs"].values())
        print(f"{r['alert_id']:<10} SEV:{r['severity']:<8} PRI:{r['priority']} -> "
              f"{r['disposition']:<10} IOCs:{ioc_count} MITRE:{len(r['mitre_attack'])}")
    print(f"ESCALATE:{summary['escalate']} INVESTIGATE:{summary['investigate']} MONITOR:{summary['monitor']}")
    print(f"RESULT   : TRIAGE COMPLETE -> {args.output}")


if __name__ == "__main__":
    main()
