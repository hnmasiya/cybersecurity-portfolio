#!/usr/bin/env python3
"""Run a deterministic hunt against the repository's synthetic process fixtures."""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from detections.detection_engine import detect_event

FIXTURES = ROOT / "fixtures" / "synthetic-process-events.json"
EXPECTED = {
    "SYN-001": ["DE-001"],
    "SYN-002": ["DE-002"],
    "SYN-003": ["DE-003"],
    "SYN-004": [],
    "SYN-005": [],
}


def build_report() -> tuple[str, bool]:
    events = json.loads(FIXTURES.read_text(encoding="utf-8"))
    if not isinstance(events, list):
        raise ValueError("Synthetic fixture must be a JSON array.")

    rows = []
    all_passed = True
    alerts_total = 0
    for event in events:
        event_id = str(event.get("event_id", "UNKNOWN"))
        actual = [alert["rule_id"] for alert in detect_event(event)]
        expected = EXPECTED.get(event_id)
        passed = expected is not None and actual == expected
        all_passed = all_passed and passed
        alerts_total += len(actual)
        result = "PASS" if passed else "FAIL"
        expected_text = ", ".join(expected) if expected else "None"
        actual_text = ", ".join(actual) if actual else "None"
        rows.append(
            f"| {event_id} | {event.get('evidence_type', 'unspecified')} | "
            f"{expected_text} | {actual_text} | {result} |"
        )

    report = [
        "# Synthetic Hunt Results: Windows Process Detection",
        "",
        "**Evidence state:** Executed by the repository's deterministic fixture runner; synthetic data only. No live endpoint, SIEM, or production hunt is claimed.",
        "",
        "## Method",
        "",
        "The runner evaluates each event in fixtures/synthetic-process-events.json with detections/detection_engine.py and compares the observed rule IDs with explicit expected outcomes. This is a repeatable logic check, not a measure of production detection efficacy.",
        "",
        "## Results",
        "",
        "| Fixture | Evidence type | Expected rule IDs | Actual rule IDs | Result |",
        "|---|---|---|---|---|",
        *rows,
        "",
        "## Summary",
        "",
        f"- Fixtures evaluated: {len(events)}",
        f"- Fixtures passing expected outcomes: {sum(1 for row in rows if row.endswith('| PASS |'))}",
        f"- Alerts emitted: {alerts_total}",
        "- Positive fixtures: 3 (SYN-001 through SYN-003)",
        "- Benign controls: 2 (SYN-004 and SYN-005)",
        f"- Overall fixture check: {'PASS' if all_passed else 'FAIL'}",
        "",
        "## Interpretation and limitations",
        "",
        "- Expected behavior is observed when the three synthetic suspicious-pattern fixtures produce their mapped alerts and both benign controls produce no alerts.",
        "- These fixtures are hand-authored examples, not collected telemetry or validated attacker behavior.",
        "- The checks do not establish precision, recall, false-positive rate, coverage, or resistance to evasion.",
        "- Sigma field mappings and behavior must still be checked against the target SIEM and its actual event schema.",
        "- Do not treat a match as proof of malicious activity; investigate process ancestry, user context, host criticality, signer, network activity, and approved administration.",
        "",
    ]
    return "\n".join(report), all_passed


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", type=Path, help="Fail if the checked-in report differs from current fixture results.")
    args = parser.parse_args()
    report, passed = build_report()
    if args.check:
        existing = args.check.read_text(encoding="utf-8")
        if existing != report:
            print(f"Report is stale: {args.check}", file=sys.stderr)
            return 1
        print(f"Report matches current fixture results: {args.check}")
    else:
        print(report, end="")
    return 0 if passed else 1


if __name__ == "__main__":
    raise SystemExit(main())
