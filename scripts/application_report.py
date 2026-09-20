#!/usr/bin/env python3
import csv
from collections import Counter
from datetime import date, timedelta
from pathlib import Path

root = Path(__file__).resolve().parents[1]
path = root / "career/applications.csv"
rows = list(csv.DictReader(path.open(encoding="utf-8"))) if path.exists() else []
cutoff = (date.today() - timedelta(days=7)).isoformat()
recent = [r for r in rows if r.get("date_applied","") >= cutoff]
counts = Counter(r.get("status","Unknown") or "Unknown" for r in rows)
lines = [
    "# Weekly Application Report",
    "",
    f"Week ending: {date.today().isoformat()}",
    f"Applications recorded: {len(rows)}",
    f"Applications in the last 7 days: {len(recent)}",
    "",
    "## Status",
    ""
]
for k,v in sorted(counts.items()):
    lines.append(f"- {k}: {v}")
lines += ["", "## Next actions", ""]
for r in rows:
    if r.get("next_action"):
        lines.append(f"- {r.get('company','')} — {r.get('role','')}: {r['next_action']} ({r.get('next_action_date','') or 'date not set'})")
(root / "career/reports").mkdir(parents=True, exist_ok=True)
out = root / "career/reports/application-weekly.md"
out.write_text("\n".join(lines) + "\n", encoding="utf-8")
print(out)
