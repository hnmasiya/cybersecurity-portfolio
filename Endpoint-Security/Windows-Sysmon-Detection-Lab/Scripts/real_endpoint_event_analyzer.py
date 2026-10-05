#!/usr/bin/env python3
"""Real-data analyzer for the Windows/Sysmon endpoint detection logic.

offline_endpoint_validator.py is a self-test harness: it compares
detections against a pre-labeled "expected_detection" field baked into
the synthetic dataset. Real telemetry has no such ground truth, so this
script instead just runs the same detect() logic against real exported
events and reports whatever findings come out, honestly, with no
pass/fail comparison.
"""
import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from offline_endpoint_validator import detect  # noqa: E402


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--input", required=True)
    p.add_argument("--output", required=True)
    args = p.parse_args()

    events = json.loads(Path(args.input).read_text())

    findings = []
    for event in events:
        for rule_id, technique, severity in detect(event):
            findings.append({
                "rule_id": rule_id,
                "mitre_technique": technique,
                "severity": severity,
                "windows_event_id": event.get("windows_event_id"),
                "image": event.get("image"),
                "command_line": event.get("command_line"),
                "parent_process": event.get("parent_process"),
                "destination_port": event.get("destination_port"),
                "timestamp": event.get("timestamp"),
            })

    summary = {
        "events_analyzed": len(events),
        "findings": len(findings),
        "high": sum(1 for f in findings if f["severity"] == "high"),
        "medium": sum(1 for f in findings if f["severity"] == "medium"),
    }

    Path(args.output).write_text(json.dumps({"summary": summary, "findings": findings}, indent=2) + "\n")

    print("WINDOWS / SYSMON REAL EVENT ANALYZER")
    print("=" * 60)
    print(f"Events analyzed : {summary['events_analyzed']}")
    print(f"Findings        : {summary['findings']}")
    for f in findings:
        print(f"{f['severity']:<8} {f['rule_id']:<10} {f['image'] or ''}")
    print(f"HIGH:{summary['high']} MEDIUM:{summary['medium']}")
    print(f"RESULT          : COMPLETE -> {args.output}")


if __name__ == "__main__":
    main()
