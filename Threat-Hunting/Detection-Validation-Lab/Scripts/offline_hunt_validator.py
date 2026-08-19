#!/usr/bin/env python3
import json
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
events = json.loads((ROOT / "Data" / "synthetic-hunt-events.json").read_text())

print("THREAT HUNTING OFFLINE VALIDATOR")
print("=" * 70)

failures = 0
results = []

failed_auth = [
    e for e in events
    if e.get("event_code") == 4625
]

counts = Counter(e.get("src_ip") for e in failed_auth)

for src_ip, count in counts.items():
    status = "PASS" if count >= 3 else "FAIL"
    if status == "FAIL":
        failures += 1

    results.append({
        "hunt": "HUNT-001",
        "src_ip": src_ip,
        "count": count,
        "threshold": 3,
        "status": status,
    })

    print(f"{status}: HUNT-001 src_ip={src_ip} failures={count} threshold=3")

for event in events:
    if event.get("image") == "powershell.exe":
        cmd = event.get("command_line", "").lower()

        if "encodedcommand" in cmd:
            status = "PASS"
            results.append({
                "hunt": "HUNT-002",
                "event_id": event["event_id"],
                "status": status,
            })
            print(f"PASS: HUNT-002 event={event['event_id']} encoded PowerShell")

        if event.get("destination_port") == 443:
            status = "PASS"
            results.append({
                "hunt": "HUNT-003",
                "event_id": event["event_id"],
                "status": status,
            })
            print(f"PASS: HUNT-003 event={event['event_id']} PowerShell network activity")

out = ROOT / "Evidence" / "hunt-validation.json"
out.write_text(json.dumps(results, indent=2) + "\n")

with (ROOT / "Evidence" / "hunt-validation.csv").open("w", newline="") as fh:
    writer = __import__("csv").writer(fh, lineterminator="\n")
    writer.writerow(["hunt", "event_or_ip", "count", "threshold", "status"])

    for r in results:
        writer.writerow([
            r.get("hunt"),
            r.get("event_id", r.get("src_ip", "")),
            r.get("count", ""),
            r.get("threshold", ""),
            r["status"],
        ])

print("=" * 70)
print("RESULT:", "PASS" if failures == 0 else "FAIL")
raise SystemExit(1 if failures else 0)
