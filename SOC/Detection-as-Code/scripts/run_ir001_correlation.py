#!/usr/bin/env python3
"""Run host/user/time correlation on the synthetic IR-001 event timeline."""
from __future__ import annotations

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from detections.correlation_engine import correlate_process_alerts

FIXTURES = ROOT / "fixtures" / "ir-001-synthetic-timeline.json"
REPORT = ROOT / "case-studies" / "IR-001-event-correlation.md"


def main() -> int:
    try:
        events = json.loads(FIXTURES.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        print(f"Fixture error: {exc}", file=sys.stderr)
        return 2

    if not isinstance(events, list) or not events:
        print("Fixture must be a non-empty JSON array.", file=sys.stderr)
        return 2

    results = correlate_process_alerts(events, window_seconds=300)
    if len(results) != 1:
        print(f"Expected one process-alert correlation anchor, found {len(results)}.", file=sys.stderr)
        return 1

    result = results[0]
    context_types = sorted(item["context_type"] for item in result["context_events"])
    expected_types = ["file", "network"]
    print(f"Anchor: {result['anchor_event_id']} rules={result['alert_rule_ids']}")
    print(f"Context events: {result['context_event_count']} types={context_types or 'none'}")

    if result["anchor_event_id"] != "IR001-E001" or context_types != expected_types:
        print("IR-001 correlation outcomes differ from expected results.", file=sys.stderr)
        return 1
    if not REPORT.is_file():
        print(f"Correlation report missing: {REPORT}", file=sys.stderr)
        return 1

    print("IR-001 correlation check PASS: one process alert linked to same-host/user network and file context.")
    print("Evidence boundary: synthetic fixtures only; correlation is context, not proof of compromise.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
