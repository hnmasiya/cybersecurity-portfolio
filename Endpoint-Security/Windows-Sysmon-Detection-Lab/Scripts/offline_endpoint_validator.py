#!/usr/bin/env python3
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
events = json.loads((ROOT / "Data" / "synthetic-endpoint-events.json").read_text())

def detect(event):
    alerts = []

    cmd = event.get("command_line", "").lower()
    image = event.get("image", "").lower()
    parent = event.get("parent_process", "").lower()

    if image == "powershell.exe" and (
        "encodedcommand" in cmd or "executionpolicy bypass" in cmd
    ):
        alerts.append(("EDR-001", "T1059.001", "high"))

    if image == "powershell.exe" and event.get("destination_port") == 443:
        alerts.append(("EDR-002", "T1059.001", "medium"))

    if event.get("windows_event_id") == 4625:
        alerts.append(("EDR-003", "T1110", "medium"))

    if parent == "powershell.exe":
        alerts.append(("EDR-004", "T1059.001", "medium"))

    return alerts

failures = 0
results = []

print("WINDOWS / SYSMON OFFLINE DETECTION VALIDATOR")
print("=" * 60)

for event in events:
    alerts = detect(event)
    names = [x[0] for x in alerts]

    expected = "No alert" not in event.get("expected_detection", "")
    passed = bool(alerts) == expected

    results.append({
        "event_id": event["event_id"],
        "detections": names,
        "expected": event["expected_detection"],
        "status": "PASS" if passed else "FAIL"
    })

    print(
        f"{'PASS' if passed else 'FAIL'}: "
        f"{event['event_id']} -> detections={names} "
        f"expected={event['expected_detection']}"
    )

    if not passed:
        failures += 1

out = ROOT / "Evidence" / "detection-validation.json"
out.write_text(json.dumps(results, indent=2) + "\n")

print("=" * 60)
print("RESULT:", "PASS" if failures == 0 else "FAIL")
raise SystemExit(1 if failures else 0)
