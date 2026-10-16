#!/usr/bin/env python3
"""Small, dependency-free detection harness for normalized Windows process events.

This is a training/reference implementation, not a SIEM replacement. It consumes
JSON events with Image, CommandLine, and optional User/ParentImage fields.
"""
from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Any


RULES = (
    {
        "id": "DE-001",
        "title": "PowerShell encoded command",
        "techniques": ["T1059.001", "T1027"],
        "severity": "medium",
    },
    {
        "id": "DE-002",
        "title": "MSHTA launched with remote URL",
        "techniques": ["T1218.005"],
        "severity": "medium",
    },
    {
        "id": "DE-003",
        "title": "Rundll32 with script or remote URL indicator",
        "techniques": ["T1218.011"],
        "severity": "medium",
    },
)


def detect_event(event: dict[str, Any]) -> list[dict[str, Any]]:
    """Return alerts for a normalized process-creation event."""
    image = str(event.get("Image", "")).strip()
    command = str(event.get("CommandLine", "")).strip()
    user = str(event.get("User", "")).strip()
    image_name = image.replace("/", "\\").rsplit("\\", 1)[-1].lower()
    command_lower = command.lower()
    alerts: list[dict[str, Any]] = []

    if image_name in {"powershell.exe", "pwsh.exe"} and re.search(
        r"(?:^|\s)-(?:enc|encodedcommand)(?:\s|:|$)", command_lower
    ):
        alerts.append(_alert(RULES[0], event, "Encoded PowerShell argument observed."))

    if image_name == "mshta.exe" and re.search(r"https?://", command_lower):
        alerts.append(_alert(RULES[1], event, "MSHTA command line contains a remote URL."))

    if image_name == "rundll32.exe" and (
        "javascript:" in command_lower or re.search(r"https?://", command_lower)
    ):
        alerts.append(_alert(RULES[2], event, "Rundll32 command line contains a script or remote URL indicator."))

    return alerts


def _alert(rule: dict[str, Any], event: dict[str, Any], reason: str) -> dict[str, Any]:
    return {
        "rule_id": rule["id"],
        "title": rule["title"],
        "severity": rule["severity"],
        "techniques": rule["techniques"],
        "reason": reason,
        "user": str(event.get("User", "")),
        "image": str(event.get("Image", "")),
        "command_line": str(event.get("CommandLine", "")),
        "parent_image": str(event.get("ParentImage", "")),
        "evidence_type": str(event.get("evidence_type", "unspecified")),
        "triage_note": "Validate parent process, user, host criticality, command context and approved administration activity before escalation.",
    }


def analyze(events: list[dict[str, Any]]) -> list[dict[str, Any]]:
    alerts: list[dict[str, Any]] = []
    for event in events:
        if not isinstance(event, dict):
            continue
        alerts.extend(detect_event(event))
    return alerts


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("input", type=Path, help="JSON file containing a list of normalized process events")
    parser.add_argument("--output", type=Path, help="Optional path for JSON alert output")
    args = parser.parse_args()

    try:
        data = json.loads(args.input.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        print(f"Input error: {exc}", file=sys.stderr)
        return 2

    if not isinstance(data, list):
        print("Input must be a JSON array of event objects.", file=sys.stderr)
        return 2

    results = analyze(data)
    output = json.dumps({"events_received": len(data), "alerts": results}, indent=2)
    if args.output:
        try:
            args.output.write_text(output + "\n", encoding="utf-8")
        except OSError as exc:
            print(f"Output error: {exc}", file=sys.stderr)
            return 2
    else:
        print(output)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
