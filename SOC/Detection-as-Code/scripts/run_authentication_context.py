#!/usr/bin/env python3
"""Validate synthetic Windows authentication context fixture structure."""
from __future__ import annotations

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FIXTURE = ROOT / "fixtures" / "authentication-context-synthetic.json"
REPORT = ROOT / "case-studies" / "authentication-context.md"


def main() -> int:
    try:
        events = json.loads(FIXTURE.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        print(f"Fixture error: {exc}", file=sys.stderr)
        return 2

    if not isinstance(events, list) or len(events) < 3:
        print("Expected at least three authentication context events.", file=sys.stderr)
        return 1
    ids = [str(event.get("event_code")) for event in events if isinstance(event, dict)]
    classifications = [event.get("expected_classification") for event in events if isinstance(event, dict)]
    if not {"4624", "4625"}.issubset(set(ids)):
        print(f"Missing expected authentication event IDs: {ids}", file=sys.stderr)
        return 1
    if not {"authentication-failure-context", "authentication-success-context", "benign-control"}.issubset(set(classifications)):
        print("Missing expected authentication classifications.", file=sys.stderr)
        return 1
    if not REPORT.is_file():
        print("Authentication context case study is missing.", file=sys.stderr)
        return 1
    print(f"Authentication context check PASS: {len(events)} synthetic events; no live identity source queried.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
