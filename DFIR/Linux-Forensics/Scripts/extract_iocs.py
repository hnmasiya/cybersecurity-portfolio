#!/usr/bin/env python3

import re
import sys
from pathlib import Path

IP_PATTERN = re.compile(
    r"\b(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)"
    r"(?:\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}\b"
)

DOMAIN_PATTERN = re.compile(
    r"\b(?:[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?\.)+"
    r"(?:com|net|org|edu|gov|mil|io|co|uk|test)\b",
    re.IGNORECASE
)

def extract_from_files(filenames):
    """Scan the given files for IPv4 and domain indicators.
    Returns (ips, domains) as sets. Missing files are skipped with a warning."""
    ips = set()
    domains = set()

    for filename in filenames:
        path = Path(filename)

        if not path.exists():
            print(f"WARNING: File not found: {path}", file=sys.stderr)
            continue

        text = path.read_text(errors="ignore")

        ips.update(IP_PATTERN.findall(text))
        domains.update(DOMAIN_PATTERN.findall(text))

    return ips, domains


def main():
    ips, domains = extract_from_files(sys.argv[1:])

    print("# IOC Extraction")
    print()
    print("## IPv4 Indicators")
    print()

    for item in sorted(ips):
        print(f"- `{item}`")

    print()
    print("## Domain Indicators")
    print()

    for item in sorted(domains):
        print(f"- `{item}`")


if __name__ == "__main__":
    main()
