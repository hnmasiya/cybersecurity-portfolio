#!/usr/bin/env python3
"""Report deadlines and follow-up dates from the persistent tracker."""
import csv
from datetime import datetime, timezone
from pathlib import Path
from email.utils import parsedate_to_datetime

CSV=Path("career/applications.csv")
OUT=Path("career/reports/deadline-followup.md")
OUT.parent.mkdir(parents=True,exist_ok=True)
now=datetime.now(timezone.utc)
rows=list(csv.DictReader(CSV.open(encoding="utf-8"))) if CSV.exists() else []
lines=["# Deadline and Follow-up Monitor","",f"Generated: {now.isoformat()}",""]
for r in rows:
    due=[]
    for field,label in [("deadline","Deadline"),("follow_up_1","Day-7 follow-up"),("follow_up_2","Day-14 follow-up")]:
        raw=(r.get(field) or "").strip()
        if not raw: continue
        try:
            d=datetime.fromisoformat(raw.replace("Z","+00:00"))
            days=(d-now).total_seconds()/86400
            if days < 0: state="OVERDUE"
            elif days <= 3: state="DUE SOON"
            else: state="scheduled"
            due.append(f"{label}: {raw} ({state})")
        except ValueError: due.append(f"{label}: {raw} (unparsed)")
    if due:
        lines += [f"## {r.get('employer','')} — {r.get('role','')}",*["- "+x for x in due],"",f"- Status: {r.get('status','')}","- Application: "+(r.get("application_url") or r.get("source_url") or "not recorded"),""]
OUT.write_text("\n".join(lines),encoding="utf-8")
print(OUT)
