#!/usr/bin/env python3
import re, sys
from pathlib import Path

root = Path(__file__).resolve().parents[1]
resume = (root / "Resume_Hazvinei_Masiya.md").read_text(encoding="utf-8").lower()
if len(sys.argv) < 2:
    raise SystemExit("Usage: python scripts/tailoring_brief.py <job-posting.txt>")
text = Path(sys.argv[1]).read_text(encoding="utf-8")
terms = sorted(set(re.findall(r"\b[a-zA-Z][a-zA-Z0-9+#./-]{2,}\b", text.lower())))
stop = {"the","and","with","for","from","that","this","are","you","your","our","will","have","has","job","role","work","team","years","experience","skills","required","preferred","about","into","using","their"}
terms = [t for t in terms if t not in stop]
hits = [t for t in terms if t in resume]
out = root / "career/reports/job-tailoring-brief.md"
lines = ["# Job Tailoring Evidence Brief", "", "## Terms found in the job posting and verified in the portfolio resume", ""]
lines += [f"- {x}" for x in hits[:100]]
lines += ["", "## Important", "", "- This is an evidence-mapping aid, not a claim generator.", "- Review the full posting manually.", "- Do not claim any requirement unless supported by the resume/portfolio evidence."]
out.write_text("\n".join(lines) + "\n", encoding="utf-8")
print(out)
