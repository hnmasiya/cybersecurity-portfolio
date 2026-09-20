#!/usr/bin/env python3
"""Create a safe application-package manifest from a tracker row."""
import argparse, csv, re
from pathlib import Path

def slug(s): return re.sub(r"[^a-z0-9]+","-",s.lower()).strip("-")[:80]
p=argparse.ArgumentParser(); p.add_argument("--row",type=int,required=True); p.add_argument("--out",default="career/Applications"); a=p.parse_args()
rows=list(csv.DictReader(Path("career/applications.csv").open(encoding="utf-8")))
r=rows[a.row-1]
root=Path(a.out)/slug(r.get("employer","employer"))/slug(r.get("role","role"))
root.mkdir(parents=True,exist_ok=True)
manifest=f"""# Application Record

- Job ID: {r.get('job_id','')}
- Canonical key: {r.get('canonical_job_key','')}
- Employer: {r.get('employer','')}
- Role: {r.get('role','')}
- Country: {r.get('country','')}
- Location: {r.get('location','')}
- Work arrangement: {r.get('work_arrangement','')}
- Application URL: {r.get('application_url','')}
- Sponsorship: {r.get('sponsorship_status','')}
- ATS status: {r.get('ats_status','')}
- Status: {r.get('status','')}
- Resume version: {r.get('resume_version','')}
- Cover-letter version: {r.get('cover_letter_version','')}

## Required artifacts
- Job-Description.md
- Tailored-Resume.pdf
- Cover-Letter.pdf
- GitHub-Evidence.md
- Sponsorship-Evidence.md
- Interview-Assessment-Pack.md

No secrets or authentication material may be stored in this package.
"""
(root/"Application-Record.md").write_text(manifest,encoding="utf-8")
print(root)
