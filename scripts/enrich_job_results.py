#!/usr/bin/env python3
import csv, re, subprocess, sys
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]
if len(sys.argv)<2: raise SystemExit("Usage: python scripts/enrich_job_results.py <jobs.csv>")
src=Path(sys.argv[1])
m=re.search(r"(\d{4}-\d{2}-\d{2})",src.name)
date=m.group(1) if m else "latest"
outdir=ROOT/"career/reports/tailored"/date
rows=list(csv.DictReader(src.open(encoding="utf-8",newline="")))
for r in rows:
    def slug(s): return re.sub(r"[^a-z0-9]+","-",s.lower()).strip("-")
    folder=outdir/(slug(r.get("company",""))+"-"+slug(r.get("title","")))[:140]
    cv=folder/"tailored-cv.md"; post=folder/"job-posting.txt"
    if cv.exists() and post.exists():
        p=subprocess.run([sys.executable,str(ROOT/"scripts/ats_validate.py"),str(cv),str(post)],capture_output=True,text=True)
        r["ats_score"]=p.stdout.strip() if p.stdout.strip() else "0"
        r["ats_pass"]="true" if p.returncode==0 else "false"
        r["tailored_path"]=str(folder.relative_to(ROOT))
    else:
        r["ats_score"]="0"; r["ats_pass"]="false"; r["tailored_path"]=""
fields=list(rows[0].keys()) if rows else ["title","company","location","url","score"]
for f in ["ats_score","ats_pass","tailored_path"]:
    if f not in fields: fields.append(f)
with src.open("w",encoding="utf-8",newline="") as f:
    w=csv.DictWriter(f,fieldnames=fields); w.writeheader(); w.writerows(rows)
print(src)
