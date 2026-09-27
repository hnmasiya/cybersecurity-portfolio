#!/usr/bin/env python3
"""Country-aware resume page policy with a hard two-page maximum."""
import argparse
import json
import re
import subprocess
from pathlib import Path

def pages(pdf: Path) -> int:
    result = subprocess.run(["pdfinfo", str(pdf)], text=True, capture_output=True, check=True)
    for line in result.stdout.splitlines():
        if line.startswith("Pages:"):
            return int(line.split(":", 1)[1].strip())
    raise RuntimeError(f"Unable to read page count from {pdf}")

def slug(value: str) -> str:
    return re.sub(r"[^a-z0-9]+", "-", value.lower()).strip("-")

def load_policy(path: Path):
    data = json.loads(path.read_text(encoding="utf-8"))
    policy = {}
    for code, profile in data.items():
        if code == "default":
            continue
        label = profile.get("label")
        target = int(profile.get("target_pages", 2))
        maximum = int(profile.get("max_pages", 2))
        if maximum > 2 or target > maximum or target < 1:
            raise ValueError(f"Invalid page policy for {code}: target={target}, max={maximum}")
        if label:
            policy[f"{slug(label)}.pdf"] = (target, maximum)
    return policy

def main():
    p = argparse.ArgumentParser()
    p.add_argument("directory", type=Path)
    p.add_argument("--expected", type=int, default=2)
    p.add_argument("--profiles", type=Path, default=Path("resume-variants/country-profiles.json"))
    a = p.parse_args()
    policy = load_policy(a.profiles) if a.profiles.exists() else {}
    pdfs = sorted(a.directory.glob("*.pdf"))
    if not pdfs:
        print("[FAIL] No resume PDFs found.")
        return 1
    failed = []
    for pdf in pdfs:
        count = pages(pdf)
        target, maximum = policy.get(pdf.name.lower(), (a.expected, 2))
        ok = count == target and count <= maximum
        print(f"[{"PASS" if ok else "FAIL"}] {pdf.name}: {count} page(s) (target {target}, max {maximum})")
        if not ok:
            failed.append((pdf.name, count, target, maximum))
    if failed:
        print("\n[FAIL] One or more resumes violate their country page target or the hard two-page maximum.")
        return 2
    print(f"\n[PASS] {len(pdfs)} resume PDFs validated against country targets with a hard maximum of 2 pages.")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
