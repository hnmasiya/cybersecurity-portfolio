#!/usr/bin/env python3
"""Normalize simple security events into a stable JSONL schema.

Safe training utility: reads a user-supplied local file and writes normalized
records. It does not contact external systems.
"""
import json
import sys
from datetime import datetime, timezone

def normalize(line: str) -> dict:
    text = line.rstrip("\n")
    return {
        "timestamp_utc": datetime.now(timezone.utc).isoformat(),
        "event_type": "raw_log",
        "message": text,
        "source": "local_training_input",
    }

def main() -> int:
    if len(sys.argv) != 3:
        print(f"usage: {sys.argv[0]} INPUT OUTPUT", file=sys.stderr)
        return 2
    with open(sys.argv[1], encoding="utf-8", errors="replace") as src, \
         open(sys.argv[2], "w", encoding="utf-8") as dst:
        for line in src:
            dst.write(json.dumps(normalize(line), ensure_ascii=False) + "\n")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
