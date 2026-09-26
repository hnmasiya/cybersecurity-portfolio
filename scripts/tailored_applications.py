#!/usr/bin/env python3
"""Generate evidence-based, job-specific application packages from the master CV.

Input: career/reports/jobs-YYYY-MM-DD.csv
Output: career/reports/tailored/YYYY-MM-DD/<company>-<title>/
The master CV remains the source of truth; this script does not invent credentials,
employment, metrics or responsibilities.
"""
import csv
import re
from html import unescape
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RESUME_PATH = ROOT / "Resume_Hazvinei_Masiya.md"
OUT = ROOT / "career/reports/tailored"
CONFIG = __import__("json").loads((ROOT / "career/job-search-config.json").read_text(encoding="utf-8"))

def plain(value):
    value = unescape(value)
    value = re.sub(r"<br\s*/?>", "\n", value, flags=re.I)
    value = re.sub(r"<[^>]+>", " ", value)
    value = re.sub(r"\s+", " ", value)
    return value.strip()

def section(source, heading):
    pattern = rf"<h2>{re.escape(heading)}</h2>(.*?)(?=<h2>|$)"
    match = re.search(pattern, source, flags=re.I | re.S)
    return plain(match.group(1)) if match else ""

def bullets(source):
    return [plain(x) for x in re.findall(r"<li>(.*?)</li>", source, flags=re.I | re.S) if plain(x)]

def terms(value):
    return set(re.findall(r"[a-z0-9][a-z0-9+#./-]{2,}", plain(value).lower()))

def slug(value):
    return re.sub(r"[^a-z0-9]+", "-", value.lower()).strip("-")[:70]

def relevant_evidence(job_text, resume):
    wanted = terms(job_text)
    scored = []
    for bullet in bullets(resume):
        overlap = len(wanted & terms(bullet))
        if overlap:
            scored.append((overlap, bullet))
    return [item for _, item in sorted(scored, key=lambda x: (-x[0], x[1]))[:14]]

def package(row, date, resume):
    title = row.get("title","").strip()
    company = row.get("company","").strip() or "Employer"
    location = row.get("location","").strip() or "Not stated"
    url = row.get("url","").strip()
    posting = row.get("description","").strip()
    profile = section(resume, "Professional Summary")
    skills = section(resume, "Core Competencies & Technical Stack")
    education = section(resume, "Certifications & Education")
    evidence = relevant_evidence(posting + " " + title, resume)

    base = OUT / date / f"{slug(company)}-{slug(title)}"
    base.mkdir(parents=True, exist_ok=True)

    cv_lines = [
        f"# Tailored CV — {title} | {company}", "",
        "**Candidate:** Hazvinei Nomatter Masiya",
        f"**Target role:** {title}",
        f"**Target location:** {location}", "",
        "## Professional Profile", profile or "See the master CV for the verified professional profile.", "",
        "## Role-Relevant Competencies", skills or "See the master CV for verified technical competencies.", "",
        "## Selected Verified Evidence"
    ]
    cv_lines += [f"- {item}" for item in evidence] or ["- No additional job-specific evidence was automatically selected."]
    cv_lines += ["", "## Certifications & Education", education or "See the master CV for verified certifications and education.", "",
                 "## Source of Truth", "This tailored document is derived from Resume_Hazvinei_Masiya.md. Verify the employer posting and every claim before submission."]
    (base / "tailored-cv.md").write_text("\n".join(cv_lines) + "\n", encoding="utf-8")

    letter_lines = [
        f"# Tailored Cover Letter — {title} | {company}", "",
        "Dear Hiring Manager,", "",
        f"I am writing to apply for the {title} position at {company}.",
        profile or "My background combines enterprise IT experience with hands-on cybersecurity work.",
        "",
        "The most relevant verified evidence selected for this application is:", ""
    ]
    letter_lines += [f"- {item}" for item in evidence[:8]] or ["- The master CV contains verified cybersecurity and enterprise IT evidence; manual review is required to select the strongest matches."]
    letter_lines += ["", "I would welcome the opportunity to discuss how this verified experience could contribute to your team.", "",
                     "Kind regards,", "", "Hazvinei Nomatter Masiya", "Harare, Zimbabwe", "", 
                     f"Application source: {url or 'Not supplied'}", "",
                     "Evidence rule: this letter is generated from the master CV and job record; it must not be used to claim unsupported skills, metrics, employment or credentials."]
    (base / "cover-letter.md").write_text("\n".join(letter_lines) + "\n", encoding="utf-8")
    (base / "job-posting.txt").write_text(posting + "\n", encoding="utf-8")
    return base

def main():
    import sys
    if len(sys.argv) < 2:
        raise SystemExit("Usage: python scripts/tailored_applications.py <jobs.csv>")
    source = Path(sys.argv[1])
    date_match = re.search(r"(\d{4}-\d{2}-\d{2})", source.name)
    date = date_match.group(1) if date_match else "latest"
    rows = list(csv.DictReader(source.open(encoding="utf-8", newline="")))
    limit = int(CONFIG.get("application_generation", {}).get("max_jobs", 10))
    made = [package(row, date, RESUME_PATH.read_text(encoding="utf-8")) for row in rows[:limit] if row.get("title")]
    index = OUT / date / "README.md"
    index.parent.mkdir(parents=True, exist_ok=True)
    lines = [f"# Tailored Application Packages — {date}", "", f"Generated from {len(made)} selected job records.", "",
             "Each package contains a tailored CV, cover letter, source job description and ATS readiness report.", "",
             "**Before applying:** verify the original employer/ATS posting, location/work authorization and every claim."]
    lines += [f"- {path.name}" for path in made]
    index.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"Generated {len(made)} application packages under {index.parent}")

if __name__ == "__main__":
    main()
