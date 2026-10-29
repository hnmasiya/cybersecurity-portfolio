#!/usr/bin/env python3
"""Validate the synthetic IR-001 timeline against expected detection outcomes."""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from detections.detection_engine import detect_event

FIXTURES = ROOT / "fixtures" / "ir-001-synthetic-timeline.json"
REPORT = ROOT / "case-studies" / "IR-001-incident-response.md"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="Check expected outcomes and report presence.")
    args = parser.parse_args()

    try:
        events = json.loads(FIXTURES.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        print(f"Fixture error: {exc}", file=sys.stderr)
        return 2

    if not isinstance(events, list) or not events:
        print("Fixture must be a non-empty JSON array.", file=sys.stderr)
        return 2

    failures = []
    alerts_total = 0
    for event in events:
        if not isinstance(event, dict):
            failures.append("Encountered a non-object event.")
            continue
        event_id = str(event.get("event_id", "UNKNOWN"))
        expected = event.get("expected_rule_ids")
        if not isinstance(expected, list):
            failures.append(f"{event_id}: expected_rule_ids must be a list.")
            continue
        actual = [alert["rule_id"] for alert in detect_event(event)]
        alerts_total += len(actual)
        if actual != expected:
            failures.append(f"{event_id}: expected {expected}, got {actual}.")
        print(f"{event_id}: expected={expected or 'none'} actual={actual or 'none'}")

    if not REPORT.is_file():
        failures.append(f"Case-study report is missing: {REPORT}")

    if failures:
        print("\n".join(failures), file=sys.stderr)
        return 1

    print(f"IR-001 synthetic check PASS: {len(events)} events, {alerts_total} alert(s); report present.")
    if not args.check:
        print("Evidence boundary: synthetic fixtures only; no live endpoint or SIEM was queried.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
