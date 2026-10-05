#!/usr/bin/env python3
"""Validate every generated resume PDF against a hard two-page maximum.

The page limit is fail-closed: a PDF is publishable only when it has 1 or 2
pages. Country targets are retained as guidance, but the hard requirement is
never more than two pages.
"""
import argparse
import json
import re
import subprocess
from pathlib import Path

REGIONAL_VARIANTS = ("europe", "africa", "middle-east", "asia-pacific", "international")


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
        if maximum > 2 or target < 1 or target > maximum:
            raise ValueError(
                f"Invalid page policy for {code}: target={target}, max={maximum}; max cannot exceed 2"
            )
        if label:
            policy[f"{slug(label)}.pdf"] = (target, maximum)
    return policy, data


def expected_pdf_names(policy):
    return set(policy) | {f"{name}.pdf" for name in REGIONAL_VARIANTS}


def main():
    p = argparse.ArgumentParser()
    p.add_argument("directory", type=Path)
    p.add_argument("--expected", type=int, default=2)
    p.add_argument("--profiles", type=Path, default=Path("resume-variants/country-profiles.json"))
    a = p.parse_args()

    policy, profile_data = load_policy(a.profiles) if a.profiles.exists() else ({}, {})
    expected_names = expected_pdf_names(policy) if policy else None
    pdfs = sorted(a.directory.glob("*.pdf"))

    if not pdfs:
        print("[FAIL] No resume PDFs found.")
        return 1

    failed = []
    actual_names = {pdf.name.lower() for pdf in pdfs}

    if expected_names:
        missing = sorted(expected_names - actual_names)
        unexpected = sorted(actual_names - expected_names)
        if missing:
            print("[FAIL] Missing expected resume PDFs:")
            for name in missing:
                print(f"  - {name}")
            failed.append(("MISSING_FILES", len(missing), len(expected_names), len(actual_names)))
        if unexpected:
            print("[FAIL] Unexpected resume PDFs:")
            for name in unexpected:
                print(f"  - {name}")
            failed.append(("UNEXPECTED_FILES", len(unexpected), len(expected_names), len(actual_names)))
        print(
            f"[INFO] Resume set: {len(actual_names)} generated; "
            f"{len(expected_names)} expected from country profiles + regional fallbacks."
        )

    for pdf in pdfs:
        count = pages(pdf)
        target, maximum = policy.get(pdf.name.lower(), (a.expected, 2))
        ok = 1 <= count <= maximum <= 2
        status = "PASS" if ok else "FAIL"
        target_note = f"target {target}, max {maximum}"
        print(f"[{status}] {pdf.name}: {count} page(s) ({target_note})")
        if not ok:
            failed.append((pdf.name, count, target, maximum))

    if failed:
        print("\n[FAIL] Resume publication blocked: every CV must be between 1 and 2 pages.")
        return 2

    print(f"\n[PASS] {len(pdfs)} resume PDFs validated. No CV exceeds the hard two-page maximum.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
