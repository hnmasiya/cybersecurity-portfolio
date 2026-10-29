#!/usr/bin/env python3
"""Offline-first enrichment for normalized detection alerts.

Reads JSON alert objects and emits enriched JSON. It does not contact external
services, block hosts, isolate endpoints, or take response actions.
"""
from __future__ import annotations

import argparse
import ipaddress
import json
import sys
from pathlib import Path
from typing import Any


def enrich_alert(alert: dict[str, Any]) -> dict[str, Any]:
    result = dict(alert)
    indicators: list[dict[str, str]] = []

    for field in ("source_ip", "destination_ip", "ip", "remote_ip"):
        raw = alert.get(field)
        if not isinstance(raw, str) or not raw.strip():
            continue
        try:
            address = ipaddress.ip_address(raw.strip())
        except ValueError:
            indicators.append({"field": field, "value": raw, "classification": "invalid_ip"})
            continue
        indicators.append({
            "field": field,
            "value": str(address),
            "classification": (
                "private_or_local" if not address.is_global
                else "public_ip_requires_reputation_lookup"
            ),
            "version": f"IPv{address.version}",
        })

    result["enrichment"] = {
        "indicators": indicators,
        "enrichment_mode": "offline",
        "external_lookup_performed": False,
        "analyst_review_required": True,
    }
    result["response_recommendation"] = {
        "action": "review_only",
        "automatic_containment": False,
        "reason": "Enrichment is contextual data, not sufficient evidence for an automated response.",
    }
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("input", type=Path, help="JSON file containing an array of alert objects")
    parser.add_argument("--output", type=Path, help="Optional output JSON path")
    args = parser.parse_args()
    try:
        data = json.loads(args.input.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        print(f"Input error: {exc}", file=sys.stderr)
        return 2
    if not isinstance(data, list) or any(not isinstance(item, dict) for item in data):
        print("Input must be a JSON array containing only alert objects.", file=sys.stderr)
        return 2
    output = json.dumps([enrich_alert(item) for item in data], indent=2) + "\n"
    try:
        if args.output:
            args.output.write_text(output, encoding="utf-8")
        else:
            print(output, end="")
    except OSError as exc:
        print(f"Output error: {exc}", file=sys.stderr)
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
