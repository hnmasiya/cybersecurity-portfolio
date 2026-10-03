#!/usr/bin/env python3
"""Wazuh Alert Export Enrichment: enriches exported Wazuh alerts with severity mapping, IOC extraction, and MITRE ATT&CK context."""
import argparse
import json
import re
from pathlib import Path

IPV4_RE = re.compile(r'\b(?:\d{1,3}\.){3}\d{1,3}\b')
SHA256_RE = re.compile(r'\b[a-fA-F0-9]{64}\b')
DOMAIN_RE = re.compile(r'\b(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,63}\b')

GROUP_MITRE = [
    ("authentication_failed", "T1110", "Brute Force", "Credential Access"),
    ("authentication_failures", "T1110", "Brute Force", "Credential Access"),
    ("web", "T1190", "Exploit Public-Facing Application", "Initial Access"),
    ("attack", "T1190", "Exploit Public-Facing Application", "Initial Access"),
    ("privilege_escalation", "T1548", "Abuse Elevation Control Mechanism", "Privilege Escalation"),
    ("sudo", "T1548", "Abuse Elevation Control Mechanism", "Privilege Escalation"),
    ("malware", "T1204", "User Execution", "Execution"),
    ("rootcheck", "T1204", "User Execution", "Execution"),
    ("recon", "T1595", "Active Scanning", "Reconnaissance"),
    ("firewall", "T1595", "Active Scanning", "Reconnaissance"),
]


def severity_for_level(level):
    if level >= 12:
        return "CRITICAL", "P1", "ESCALATE"
    if level >= 9:
        return "HIGH", "P2", "ESCALATE"
    if level >= 6:
        return "MEDIUM", "P3", "INVESTIGATE"
    return "LOW", "P4", "MONITOR"


def extract_iocs(text):
    return {
        "ipv4": sorted(set(IPV4_RE.findall(text))),
        "domains": sorted(set(d for d in DOMAIN_RE.findall(text) if not IPV4_RE.fullmatch(d))),
        "sha256": sorted(set(SHA256_RE.findall(text))),
    }


def map_mitre(groups):
    hits = []
    seen = set()
    for g in groups:
        for kw, tech, name, tactic in GROUP_MITRE:
            if kw == g and tech not in seen:
                hits.append({"technique": tech, "name": name, "tactic": tactic})
                seen.add(tech)
    return hits


def enrich_alert(alert):
    rule = alert.get("rule", {})
    agent = alert.get("agent", {})
    data = alert.get("data", {})
    level = int(rule.get("level", 0))
    severity, priority, disposition = severity_for_level(level)

    text_blob = " ".join([alert.get("full_log", ""), json.dumps(data)])
    iocs = extract_iocs(text_blob)

    return {
        "timestamp": alert.get("timestamp", ""),
        "rule_id": rule.get("id", ""),
        "rule_description": rule.get("description", ""),
        "rule_level": level,
        "severity": severity,
        "priority": priority,
        "disposition": disposition,
        "agent": agent.get("name", ""),
        "iocs": iocs,
        "mitre_attack": map_mitre(rule.get("groups", [])),
    }


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--input", required=True)
    p.add_argument("--output", required=True)
    args = p.parse_args()

    alerts = json.loads(Path(args.input).read_text())
    results = [enrich_alert(a) for a in alerts]

    summary = {"total": len(results)}
    for k in ("ESCALATE", "INVESTIGATE", "MONITOR"):
        summary[k.lower()] = sum(1 for r in results if r["disposition"] == k)

    Path(args.output).write_text(json.dumps({"summary": summary, "alerts": results}, indent=2))

    print("WAZUH ALERT ENRICHMENT")
    print(f"Alerts processed : {summary['total']}")
    for r in results:
        ioc_count = sum(len(v) for v in r["iocs"].values())
        print(f"{r['rule_id']:<6} L{r['rule_level']:<3} {r['severity']:<8} PRI:{r['priority']} -> "
              f"{r['disposition']:<10} IOCs:{ioc_count} MITRE:{len(r['mitre_attack'])}")
    print(f"ESCALATE:{summary['escalate']} INVESTIGATE:{summary['investigate']} MONITOR:{summary['monitor']}")
    print(f"RESULT           : COMPLETE -> {args.output}")


if __name__ == "__main__":
    main()
