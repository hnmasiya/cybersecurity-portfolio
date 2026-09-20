#!/usr/bin/env python3
"""Generate evidence-based, job-specific application packages.

Input: career/reports/jobs-YYYY-MM-DD.csv
Output: career/reports/tailored/YYYY-MM-DD/*.md
No claim is generated unless it is already supported by Resume_Hazvinei_Masiya.md.
"""
import csv, re, sys
from pathlib import Path
from html import unescape

ROOT = Path(__file__).resolve().parents[1]
RESUME = (ROOT / "Resume_Hazvinei_Masiya.md").read_text(encoding="utf-8")
OUT = ROOT / "career/reports/tailored"

ROLE_FOCUS = {
    "soc": ["SIEM", "Wazuh", "Sysmon", "incident", "detection", "threat", "security"],
    "security": ["security", "incident", "SIEM", "Wazuh", "Windows", "Active Directory", "access", "vulnerability"],
    "detection": ["detection", "Wazuh", "Sysmon", "MITRE", "Python", "logs", "SIEM"],
    "incident": ["incident", "DFIR", "forensics", "logs", "PCAP", "investigation"],
    "threat": ["threat", "hunting", "PCAP", "IOC", "MITRE", "SIEM"],
    "engineer": ["Python", "PowerShell", "Wazuh", "Sysmon", "cloud", "Terraform", "automation"],
}

def clean(s):
    return re.sub(r"[^a-z0-9]+", " ", unescape(s).lower()).strip()

def terms(text):
    return set(re.findall(r"[a-z0-9+#./-]{3,}", clean(text)))

def relevant_bullets(job_text):
    wanted = terms(job_text)
    bullets = []
    for line in RESUME.splitlines():
        if re.match(r"\s*[-*]\s+", line):
            b = re.sub(r"^\s*[-*]\s+", "", line).strip()
            score = len(wanted & terms(b))
            if score:
                bullets.append((score, b))
    return [b for _, b in sorted(bullets, key=lambda x: (-x[0], x[1]))[:14]]

def focus_for(title):
    t = clean(title)
    for key, vals in ROLE_FOCUS.items():
        if key in t:
            return vals
    return ["security", "SIEM", "Windows", "Active Directory", "Python", "incident"]

def slug(s):
    return re.sub(r"[^a-z0-9]+", "-", s.lower()).strip("-")[:70]

def package(row, date):
    title = row.get("title","").strip()
    company = row.get("company","").strip() or "Employer"
    location = row.get("location","").strip()
    url = row.get("url","").strip() or row.get("job_url","").strip()
    desc = row.get("description","") or row.get("summary","")
    focus = focus_for(title)
    evidence = relevant_bullets(desc + " " + " ".join(focus))
    base = OUT / date / f"{slug(company)}-{slug(title)}"
    base.mkdir(parents=True, exist_ok=True)

    cv = f"""# Tailored CV — {title} | {company}

**Candidate:** Hazvinei Nomatter Masiya  
**Target role:** {title}  
**Location:** {location}

## Professional Profile
CompTIA Security+ certified enterprise IT professional with 12+ years of experience across IT support, infrastructure, systems administration, access control, endpoint security and security-conscious technical operations. Hands-on cybersecurity work includes SIEM detection engineering, Windows/Sysmon telemetry, incident investigation, DFIR, threat hunting and security automation.

## Role-Focused Skills
{chr(10).join("- " + x for x in focus)}

## Verified Evidence Selected From the Master CV
{chr(10).join("- " + x for x in evidence) if evidence else "- No additional job-specific evidence was automatically selected; review the posting manually before applying."}

## Certifications & Education
- CompTIA Security+ (SY0-701)
- Google Cybersecurity Professional Certificate
- Google IT Support Professional Certificate
- BSc in Computer Science — Unicaf University (In Progress)
- National Diploma in Information Communication Technology — Harare Polytechnic

## Portfolio
- GitHub: https://github.com/hnmasiya
- Portfolio: https://masiya-hub.org
- LinkedIn: https://www.linkedin.com/in/hazvinei-masiya

## Integrity Check
This tailored CV is derived from the existing master CV. It must not be used to claim skills, employment, metrics, certifications or responsibilities that are not supported by the master CV or verified application evidence.
"""
    letter = f"""# Tailored Cover Letter — {title} | {company}

Dear Hiring Manager,

I am writing to apply for the {title} position at {company}. I am a CompTIA Security+ certified IT professional with 12+ years of enterprise IT and infrastructure experience, now focused on cybersecurity operations, detection, investigation and security automation.

My background combines practical enterprise support and infrastructure work with hands-on security projects involving Wazuh SIEM, Sysmon telemetry, MITRE ATT&CK mapping, Windows and Active Directory security events, Linux incident response/DFIR, PCAP analysis and Python-based security automation. The experience most relevant to this posting includes:

{chr(10).join("- " + x for x in evidence[:8]) if evidence else "- My application materials contain verified cybersecurity and enterprise IT evidence; the posting should be reviewed manually for the strongest matches."}

I would welcome the opportunity to discuss how this combination of enterprise IT experience and hands-on cybersecurity work could contribute to your team.

Kind regards,

Hazvinei Nomatter Masiya
Harare, Zimbabwe
norman.masiya@gmail.com
+263 77 521 6823 / +263 71 866 2162
https://github.com/hnmasiya
https://masiya-hub.org
https://www.linkedin.com/in/hazvinei-masiya

---
**Application source:** {url}
**Evidence rule:** This letter contains only claims intended to be supported by the existing master CV; verify the employer posting before submission.
"""
    (base / "tailored-cv.md").write_text(cv, encoding="utf-8")
    (base / "cover-letter.md").write_text(letter, encoding="utf-8")
    (base / "job-posting.txt").write_text(desc, encoding="utf-8")
    return base

def main():
    if len(sys.argv) < 2:
        raise SystemExit("Usage: python scripts/tailored_applications.py <jobs.csv>")
    src = Path(sys.argv[1])
    date = re.search(r"(\d{4}-\d{2}-\d{2})", src.name)
    date = date.group(1) if date else "latest"
    rows = list(csv.DictReader(src.open(encoding="utf-8", newline="")))
    made = []
    for row in rows[:10]:
        title = row.get("title","")
        if not title:
            continue
        made.append(package(row, date))
    index = OUT / date / "README.md"
    lines = [f"# Tailored Application Packages — {date}", "", f"Generated from {len(made)} matching job records.", "",
             "Each package contains a tailored CV, cover letter and the source job description.", "",
             "**Before applying:** verify the original employer/ATS posting, salary/location/eligibility, and every claim."]
    for p in made:
        lines.append(f"- [{p.name}](./{p.name}/)")
    index.parent.mkdir(parents=True, exist_ok=True)
    index.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"Generated {len(made)} application packages under {index.parent}")

if __name__ == "__main__":
    main()
