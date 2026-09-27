#!/usr/bin/env python3
"""Build country-aware resume sources from one verified master resume.

The master resume is the sole factual source. Country profiles control
presentation only; they must never invent qualifications, employment,
nationality, work authorisation, clearance, salary, clients, metrics or
other claims.

All publishable PDFs are validated separately and must pass the exact
two-page quality gate before publication.
"""
from pathlib import Path
import json
import re

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "Resume_Hazvinei_Masiya.md"
PROFILES = ROOT / "resume-variants/country-profiles.json"
OUT = ROOT / "dist/resumes"

source = SOURCE.read_text(encoding="utf-8")
profiles = json.loads(PROFILES.read_text(encoding="utf-8"))
OUT.mkdir(parents=True, exist_ok=True)

regional = {
    "europe": {"label": "European CV", "page_size": "A4"},
    "africa": {"label": "African CV", "page_size": "A4"},
    "middle-east": {"label": "Middle East Resume", "page_size": "A4"},
    "asia-pacific": {"label": "Asia-Pacific Resume", "page_size": "A4"},
    "international": {"label": "International Resume", "page_size": "A4"},
}

def slug(value: str) -> str:
    return re.sub(r"[^a-z0-9]+", "-", value.lower()).strip("-")

targets = {code: profile for code, profile in profiles.items() if code != "default"}
targets.update({key.upper(): profile for key, profile in regional.items()})

for key, profile in targets.items():
    label = profile["label"]
    page = profile.get("page_size", "A4")
    margin = profile.get("margin", "0.36in 0.48in")

    text = source
    text = re.sub(
        r"@page\s*\{[^}]*\}",
        f"@page {{ size: {page}; margin: {margin}; }}",
        text,
        count=1,
        flags=re.S,
    )
    text = re.sub(
        r"<h2>Global Application Profile</h2>.*?<h2>Core Competencies & Technical Stack</h2>",
        "<h2>Core Competencies & Technical Stack</h2>",
        text,
        count=1,
        flags=re.S,
    )
    text = text.replace(
        "Global opportunities: Remote · Hybrid · On-site · Relocation",
        "Remote · Hybrid · On-site · Relocation",
        1,
    )
    text = re.sub(
        r"<!--.*?-->",
        f"<!-- Country profile: {label}. Generated from the verified master resume. -->",
        text,
        count=1,
        flags=re.S,
    )

    (OUT / f"{slug(label)}.md").write_text(text, encoding="utf-8")

print(f"Generated {len(targets)} country/regional resume sources in {OUT}")
