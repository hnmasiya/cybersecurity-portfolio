#!/usr/bin/env python3
"""Evidence-safe ATS readiness validator. No numeric score is produced."""
import argparse, re, sys
from pathlib import Path

def text(path):
    return Path(path).read_text(encoding="utf-8", errors="ignore")

def words(s):
    return set(re.findall(r"[a-z0-9][a-z0-9+#./-]{2,}", s.lower()))

def main():
    p=argparse.ArgumentParser()
    p.add_argument("--job",required=True)
    p.add_argument("--resume",required=True)
    p.add_argument("--required",default="")
    p.add_argument("--out",default="career/reports/ats-readiness.md")
    a=p.parse_args()
    job=text(a.job); resume=text(a.resume)
    j=words(job); r=words(resume)
    required=[x.strip().lower() for x in a.required.split(",") if x.strip()]
    missing=[x for x in required if x not in resume.lower()]
    checks=[]
    checks.append(("PDF/text extractability", bool(resume.strip())))
    checks.append(("Required keywords supplied", not missing))
    checks.append(("Job-title alignment", any(x in resume.lower() for x in ["cybersecurity","security","soc","information security","security operations"])))
    checks.append(("Certifications", any(x in resume.lower() for x in ["security+","google cybersecurity","comp tia"])))
    checks.append(("Education", any(x in resume.lower() for x in ["information communication technology","computer science","harare polytechnic"])))
    checks.append(("Unsupported-claim guard", not any(x in resume.lower() for x in ["guaranteed","expert in all","100% success"])))
    status="PASS" if all(v for _,v in checks) else "NEEDS REVISION"
    out=Path(a.out); out.parent.mkdir(parents=True,exist_ok=True)
    lines=["# ATS Readiness",f"Status: **{status}**","","> This is a rule-based readiness check, not a guarantee of ATS acceptance.",""]
    for name,ok in checks: lines.append(f"- {'PASS' if ok else 'NEEDS REVISION'} — {name}")
    if missing: lines += ["","Missing supplied required terms: "+", ".join(missing)]
    out.write_text("\n".join(lines)+"\n",encoding="utf-8")
    print(status)
    return 0 if status=="PASS" else 2

if __name__=="__main__":
    raise SystemExit(main())
