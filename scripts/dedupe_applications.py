#!/usr/bin/env python3
"""Detect likely duplicate applications across job boards."""
import csv, hashlib, re, sys
from pathlib import Path

CSV=Path("career/applications.csv")
def norm(s): return re.sub(r"[^a-z0-9]+"," ",(s or "").lower()).strip()
rows=list(csv.DictReader(CSV.open(encoding="utf-8"))) if CSV.exists() else []
seen={}
dupes=[]
for i,row in enumerate(rows,1):
    key=row.get("canonical_job_key") or "|".join([norm(row.get("employer")),norm(row.get("role")),norm(row.get("country")),norm(row.get("location"))])
    url=norm(row.get("application_url") or row.get("source_url"))
    ident=hashlib.sha256((key+"|"+url).encode()).hexdigest()
    if ident in seen: dupes.append((seen[ident],i,key))
    else: seen[ident]=i
print(f"Records checked: {len(rows)}")
if dupes:
    print("Potential duplicates:")
    for a,b,k in dupes: print(f"- rows {a} and {b}: {k}")
    sys.exit(2)
print("No duplicate application records detected.")
