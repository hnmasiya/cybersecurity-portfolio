from pathlib import Path
from datetime import date
import json

root=Path(__file__).resolve().parents[1]
cfg=json.loads((root/"career/job-search-config.json").read_text())
roles=cfg["profile"]["primary_roles"]+cfg["profile"]["secondary_roles"]
keywords=cfg["profile"]["keywords"]
out=root/"career/reports"
out.mkdir(parents=True,exist_ok=True)
lines=[
"# Weekly Cybersecurity Interview Pack","",
f"Generated: {date.today().isoformat()}","",
"## Target roles","",
* [f"- {r}" for r in roles],
"",
"## Technical focus","",
* [f"- Explain and demonstrate your evidence for **{k}**." for k in keywords],
"",
"## STAR preparation","",
"- Situation: state the environment and scope accurately.",
"- Task: explain your responsibility.",
"- Action: describe what you actually did.",
"- Result: state the observed result; do not invent metrics.",
"- Evidence: identify the repository, lab, certificate, or documented artifact supporting the story.",
"",
"## Truthfulness checks","",
"- Separate paid employment from independent labs.",
"- Separate Forage virtual simulations from employment.",
"- Never invent production access, incident ownership, metrics, clearance, or certifications.",
]
(out/"interview-weekly.md").write_text("\n".join(lines)+"\n")
print(out/"interview-weekly.md")
