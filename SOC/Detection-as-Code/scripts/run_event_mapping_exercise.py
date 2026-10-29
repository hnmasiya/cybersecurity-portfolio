#!/usr/bin/env python3
"""Print mapping results for offline Windows process event examples."""
import sys
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from detections.event_mapping import normalize_process_event
from detections.detection_engine import detect_event

SAMPLES = [
    ("flat-normalized", {"EventID": "1", "Image": r"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe", "CommandLine": "powershell.exe -EncodedCommand SQBFAFgA", "ParentImage": r"C:\Windows\System32\cmd.exe", "User": "LAB\\analyst"}),
    ("wazuh-like-envelope", {"data": {"win": {"system": {"eventID": "1"}, "eventdata": {"image": r"C:\Windows\System32\mshta.exe", "commandLine": "mshta.exe https://example.invalid/demo.hta", "parentImage": r"C:\Windows\explorer.exe", "user": "LAB\\analyst", "processId": "2000"}}}}),
    ("incomplete-event", {"EventID": "1", "User": "LAB\\analyst"}),
]

def main():
    print("| Sample | Event ID | Mapping status | Image | Detection IDs |")
    print("|---|---:|---|---|---|")
    ok = True
    for label, raw in SAMPLES:
        event = normalize_process_event(raw)
        alerts = detect_event(event) if event["mapping_status"] == "ready_for_reference_harness" else []
        ids = ", ".join(alert["rule_id"] for alert in alerts) or "None"
        image = event["Image"] or "—"
        event_id = event["EventID"] or "—"
        print(f"| {label} | {event_id} | {event['mapping_status']} | {image} | {ids} |")
        expected = "incomplete_required_fields" if label == "incomplete-event" else "ready_for_reference_harness"
        ok = ok and event["mapping_status"] == expected
    print("\nSynthetic examples only; no live SIEM data was read.")
    return 0 if ok else 1

if __name__ == "__main__":
    raise SystemExit(main())
