#!/usr/bin/env python3
"""Deterministic ATS-readiness validator. This is a quality gate, not a guarantee of ATS acceptance."""
import re, sys
from pathlib import Path

REQUIRED = ["professional profile", "role-focused skills", "verified evidence", "certifications", "education"]
BAD = ["<table", "| ---", "![", "<img", "<svg", "columns"]
def score(text, posting):
    t=text.lower()
    p=posting.lower()
    checks=[]
    checks.append(("required sections", sum(x in t for x in REQUIRED) / len(REQUIRED) * 25))
    checks.append(("contact", 10 if "norman.masiya@gmail.com" in t else 0))
    checks.append(("plain text structure", 15 if not any(x in t for x in BAD) else 0))
    keywords=set(re.findall(r"[a-z][a-z0-9+#./-]{2,}", p))
    resume_words=set(re.findall(r"[a-z][a-z0-9+#./-]{2,}", t))
    meaningful={x for x in keywords if len(x)>3 and x not in {"experience","required","preferred","candidate","position","company","role","team"}}
    coverage=(len(meaningful & resume_words)/len(meaningful)*100) if meaningful else 100
    checks.append(("posting keyword coverage", min(30, coverage*0.30)))
    checks.append(("readability", 20 if len(text.splitlines()) < 180 and len(text) < 30000 else 10))
    total=round(sum(v for _,v in checks),1)
    return total, checks

if len(sys.argv)<3: raise SystemExit("Usage: python scripts/ats_validate.py <tailored-cv.md> <job-posting.txt>")
cv=Path(sys.argv[1]).read_text(encoding="utf-8")
post=Path(sys.argv[2]).read_text(encoding="utf-8")
s, checks=score(cv,post)
out=Path(sys.argv[1]).with_name("ats-report.md")
lines=["# ATS Readiness Report","",f"**Deterministic score: {s}/100**","","> This is an internal quality gate, not a guarantee that any employer ATS will accept, rank or select the resume.",""]
for n,v in checks: lines.append(f"- **{n}:** {v:.1f}")
lines += ["","## Gate","", "- PASS" if s >= 85 else "- FAIL", "", "No unsupported claims are added by this validator."]
out.write_text("\\n".join(lines)+"\\n",encoding="utf-8")
print(s)
if s < 85: raise SystemExit(2)
