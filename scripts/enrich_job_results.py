#!/usr/bin/env python3
import csv
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if len(sys.argv) < 2:
    raise SystemExit("Usage: python scripts/enrich_job_results.py <jobs.csv>")
src = Path(sys.argv[1])
date_match = re.search(r"(\d{4}-\d{2}-\d{2})", src.name)
date = date_match.group(1) if date_match else "latest"
resume = ROOT / "Resume_Hazvinei_Masiya.md"
required = ",".join(__import__("json").loads((ROOT / "career/job-search-config.json").read_text(encoding="utf-8")).get("application_generation", {}).get("ats_required_terms", []))
rows = list(csv.DictReader(src.open(encoding="utf-8", newline="")))
if not rows:
    raise SystemExit("No job matches were generated; ATS enrichment cannot proceed.")

for row in rows:
    company = re.sub(r"[^a-z0-9]+", "-", row.get("company","").lower()).strip("-") or "employer"
    title = re.sub(r"[^a-z0-9]+", "-", row.get("title","").lower()).strip("-") or "role"
    folder = (ROOT / "career/reports/tailored" / date / f"{company}-{title}") 
    cv = folder / "tailored-cv.md"
    posting = folder / "job-posting.txt"
    report = folder / "ats-readiness.md"
    if not cv.exists() or not posting.exists():
        row["ats_pass"] = "false"
        row["ats_status"] = "NEEDS REVISION"
        row["tailored_path"] = ""
        continue

    result = subprocess.run([
        sys.executable, str(ROOT / "scripts/ats_validate.py"),
        "--job", str(posting),
        "--resume", str(cv),
        "--required", required,
        "--out", str(report)
    ], capture_output=True, text=True)
    row["ats_pass"] = "true" if result.returncode == 0 else "false"
    row["ats_status"] = "PASS" if result.returncode == 0 else "NEEDS REVISION"
    row["tailored_path"] = str(folder.relative_to(ROOT))

fields = list(rows[0].keys())
for field in ("ats_pass","ats_status","tailored_path"):
    if field not in fields:
        fields.append(field)
with src.open("w", encoding="utf-8", newline="") as handle:
    writer = csv.DictWriter(handle, fieldnames=fields)
    writer.writeheader()
    writer.writerows(rows)
if any(row.get("ats_pass") != "true" for row in rows):
    raise SystemExit("ATS readiness gate failed for one or more generated applications.")
print(src)
