#!/usr/bin/env python3
import csv, json, re, sys
from datetime import datetime, timezone
from pathlib import Path
from urllib.request import Request, urlopen

ROOT = Path(__file__).resolve().parents[1]
CONFIG = json.loads((ROOT / "career/job-search-config.json").read_text())
OUT = ROOT / "career/reports"
OUT.mkdir(parents=True, exist_ok=True)

def fetch_json(url):
    req = Request(url, headers={"User-Agent": "hnmasiya-career-intelligence/1.0"})
    with urlopen(req, timeout=30) as r:
        return json.loads(r.read().decode("utf-8"))

def norm(x):
    return re.sub(r"\s+", " ", str(x or "")).strip()

def score(job):
    text = norm(" ".join([job.get("title",""), job.get("description",""), job.get("category",""), job.get("tags","")])).lower()
    inc = [x.lower() for x in CONFIG["filters"]["include_terms"]]
    exc = [x.lower() for x in CONFIG["filters"]["exclude_terms"]]
    hits = [x for x in inc if x in text]
    bad = [x for x in exc if x in text]
    return len(hits) * 3 - len(bad) * 10, hits, bad

def normalize_arbeitnow(item, source):
    return {
        "title": norm(item.get("title")),
        "company": norm(item.get("company_name")),
        "location": norm(item.get("location")),
        "remote": str(item.get("remote", "")),
        "url": item.get("url",""),
        "description": norm(item.get("description")),
        "source": source,
        "published": item.get("created_at","")
    }

def normalize_remotive(item, source):
    return {
        "title": norm(item.get("title")),
        "company": norm(item.get("company_name")),
        "location": norm(item.get("candidate_required_location")),
        "remote": "remote",
        "url": item.get("url",""),
        "description": norm(item.get("description")),
        "source": source,
        "published": item.get("publication_date","")
    }

jobs = []
errors = []
for source in CONFIG["sources"]:
    try:
        data = fetch_json(source["url"])
        if source["type"] == "arbeitnow":
            for item in data.get("data", []):
                jobs.append(normalize_arbeitnow(item, source["name"]))
        elif source["type"] == "remotive":
            for item in data.get("jobs", []):
                jobs.append(normalize_remotive(item, source["name"]))
    except Exception as e:
        errors.append(f'{source["name"]}: {e}')

unique = {}
for j in jobs:
    if not j["url"]:
        continue
    key = j["url"]
    s, hits, bad = score(j)
    if bad or s <= 0:
        continue
    j["match_score"] = s
    j["matched_terms"] = hits
    unique[key] = j

selected = sorted(unique.values(), key=lambda x: (-x["match_score"], x["title"]))[:CONFIG["filters"]["max_results"]]
stamp = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
date = datetime.now(timezone.utc).strftime("%Y-%m-%d")

csv_path = OUT / f"jobs-{date}.csv"
with csv_path.open("w", newline="", encoding="utf-8") as f:
    w = csv.DictWriter(f, fieldnames=["match_score","title","company","location","remote","source","published","url","matched_terms"])
    w.writeheader()
    for j in selected:
        row = {k:j.get(k,"") for k in w.fieldnames}
        row["matched_terms"] = ", ".join(j["matched_terms"])
        w.writerow(row)

md_path = OUT / f"jobs-{date}.md"
lines = [f"# Cybersecurity Job Intelligence — {date}", "", f"Generated: {stamp}", "", "Discovery results only. Verify the original employer/ATS posting before applying.", ""]
if errors:
    lines += ["## Source warnings", ""] + [f"- {e}" for e in errors] + [""]
for i, j in enumerate(selected, 1):
    lines += [f"## {i}. {j['title']}", f"- **Company:** {j['company'] or 'Not stated'}", f"- **Location:** {j['location'] or 'Not stated'}", f"- **Remote:** {j['remote'] or 'Not stated'}", f"- **Match signals:** {', '.join(j['matched_terms'])}", f"- **Source:** {j['source']}", f"- **Job:** {j['url']}", ""]
md_path.write_text("\n".join(lines), encoding="utf-8")
print(f"Generated {len(selected)} job matches")
print(md_path)
print(csv_path)
