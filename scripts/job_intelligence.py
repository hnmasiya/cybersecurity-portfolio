#!/usr/bin/env python3
import csv
import json
import os
import re
from datetime import datetime, timezone
from pathlib import Path
from urllib.request import Request, urlopen

ROOT = Path(__file__).resolve().parents[1]
CONFIG = json.loads((ROOT / "career/job-search-config.json").read_text(encoding="utf-8"))
OUT = ROOT / "career/reports"
OUT.mkdir(parents=True, exist_ok=True)

def fetch_json(url):
    req = Request(url, headers={"User-Agent": "hnmasiya-career-intelligence/3.0"})
    with urlopen(req, timeout=30) as response:
        return json.loads(response.read().decode("utf-8"))

def norm(value):
    return re.sub(r"\s+", " ", str(value or "")).strip()

def contains_term(text, term):
    text = text.lower()
    term = norm(term).lower()
    if not term:
        return False
    if re.fullmatch(r"[a-z0-9]+", term) and len(term) <= 4:
        return bool(re.search(rf"\b{re.escape(term)}\b", text))
    return term in text

def find_terms(text, terms):
    return [term for term in terms if contains_term(text, term)]

def score(job):
    title = norm(job.get("title")).lower()
    body = norm(" ".join([job.get("description",""), job.get("category",""), job.get("tags","")])).lower()
    filters = CONFIG["filters"]
    title_hits = find_terms(title, filters.get("title_include_terms", []))
    blocked = find_terms(title, filters.get("title_block_terms", []))
    excluded = find_terms(title, filters.get("title_exclude_terms", []))

    technical_title_terms = ("engineer","developer","architect","analyst","administrator","consultant","specialist","researcher","tester","operations")
    if contains_term(title, "security") and any(contains_term(title, term) for term in technical_title_terms):
        title_hits.append("security")

    if blocked or excluded or not title_hits:
        return None

    context_hits = find_terms(" ".join([title, body]), filters.get("context_include_terms", []))
    match_score = len(title_hits) * 10 + min(len(context_hits), 8) * 2
    matched = title_hits + [item for item in context_hits if item not in title_hits]
    return match_score, matched

def normalize_arbeitnow(item, source):
    return {
        "title": norm(item.get("title")),
        "company": norm(item.get("company_name")),
        "location": norm(item.get("location")),
        "remote": str(item.get("remote", "")),
        "url": item.get("url", ""),
        "description": norm(item.get("description")),
        "source": source,
        "published": item.get("created_at", "")
    }

def normalize_remotive(item, source):
    return {
        "title": norm(item.get("title")),
        "company": norm(item.get("company_name")),
        "location": norm(item.get("candidate_required_location")),
        "remote": "remote",
        "url": item.get("url", ""),
        "description": norm(item.get("description")),
        "source": source,
        "published": item.get("publication_date", "")
    }

def normalize_greenhouse(item, board_token):
    location = item.get("location") or {}
    return {
        "title": norm(item.get("title")),
        "company": norm(item.get("company_name")) or board_token,
        "location": norm(location.get("name")),
        "remote": "",
        "url": item.get("absolute_url", ""),
        "description": norm(item.get("content")),
        "source": f"Greenhouse:{board_token}",
        "published": item.get("updated_at", "")
    }

def normalize_adzuna(item, source):
    company = item.get("company") or {}
    location = item.get("location") or {}
    return {
        "title": norm(item.get("title")),
        "company": norm(company.get("display_name")),
        "location": norm(location.get("display_name")),
        "remote": "",
        "url": item.get("redirect_url", ""),
        "description": norm(item.get("description")),
        "source": source,
        "published": item.get("created", "")
    }

def dedupe_key(job):
    parts = [job.get("title",""), job.get("company",""), job.get("location","")]
    return "||".join(re.sub(r"[^a-z0-9]+"," ",norm(x).lower()).strip() for x in parts)

def run():
    jobs = []
    errors = []
    for source in CONFIG["sources"]:
        try:
            typ = source["type"]
            if typ in ("arbeitnow","remotive"):
                data = fetch_json(source["url"])
                items = data.get("data", []) if typ == "arbeitnow" else data.get("jobs", [])
                normalizer = normalize_arbeitnow if typ == "arbeitnow" else normalize_remotive
                for item in items:
                    jobs.append(normalizer(item, source["name"]))
            elif typ == "greenhouse":
                tokens = [x.strip() for x in os.getenv("GREENHOUSE_BOARD_TOKENS","").split(",") if x.strip()]
                if not tokens:
                    errors.append("Greenhouse public boards: GREENHOUSE_BOARD_TOKENS not configured; source skipped.")
                    continue
                for token in tokens:
                    data = fetch_json(source["url"].format(board_token=token))
                    for item in data.get("jobs", []):
                        jobs.append(normalize_greenhouse(item, token))
            elif typ == "adzuna":
                app_id = os.getenv("ADZUNA_APP_ID")
                app_key = os.getenv("ADZUNA_APP_KEY")
                if not app_id or not app_key:
                    errors.append("Adzuna: ADZUNA_APP_ID/ADZUNA_APP_KEY not configured; source skipped.")
                    continue
                countries = ("us","ca","mx","gb","de","fr","nl","au","nz","za","ae","ie","es","it","se")
                for country in countries:
                    url = source["url"].format(country=country)
                    data = fetch_json(url + f"?app_id={app_id}&app_key={app_key}&results_per_page=50&what=cybersecurity")
                    for item in data.get("results", []):
                        jobs.append(normalize_adzuna(item, source["name"]))
        except Exception as exc:
            errors.append(f'{source["name"]}: {exc}')

    unique = {}
    for job in jobs:
        if not job["url"]:
            continue
        result = score(job)
        if result is None:
            continue
        match_score, matched = result
        job["match_score"] = match_score
        job["matched_terms"] = matched
        key = dedupe_key(job)
        previous = unique.get(key)
        if previous is None or (job["match_score"], job.get("published","")) > (previous["match_score"], previous.get("published","")):
            unique[key] = job

    selected = sorted(unique.values(), key=lambda x: (-x["match_score"], x["title"].lower(), x["company"].lower()))[:CONFIG["filters"]["max_results"]]
    date = datetime.now(timezone.utc).strftime("%Y-%m-%d")
    csv_path = OUT / f"jobs-{date}.csv"
    fields = ["match_score","title","company","location","remote","source","published","url","matched_terms"]
    with csv_path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields)
        writer.writeheader()
        for job in selected:
            row = {key: job.get(key,"") for key in fields}
            row["matched_terms"] = ", ".join(job["matched_terms"])
            writer.writerow(row)

    md_path = OUT / f"jobs-{date}.md"
    lines = [
        f"# Cybersecurity Job Intelligence — {date}", "",
        "Generated: __TIMESTAMP__", "",
        "Discovery results only. Verify the original employer/ATS posting before applying.", "",
        "Strict relevance filter: a security-specific signal must appear in the job title; generic roles do not qualify from description-only keyword matches.", ""
    ]
    if errors:
        lines += ["## Source warnings", ""] + [f"- {error}" for error in errors] + [""]
    for i, job in enumerate(selected, 1):
        lines += [
            f"## {i}. {job['title']}",
            f"- **Company:** {job['company'] or 'Not stated'}",
            f"- **Location:** {job['location'] or 'Not stated'}",
            f"- **Remote:** {job['remote'] or 'Not stated'}",
            f"- **Match score:** {job['match_score']}",
            f"- **Match signals:** {', '.join(job['matched_terms'])}",
            f"- **Source:** {job['source']}",
            f"- **Job:** {job['url']}", ""
        ]

    new_content = "\n".join(lines)
    existing = md_path.read_text(encoding="utf-8") if md_path.exists() else ""
    normalized = re.sub(r"(?m)^Generated: .*?$", "Generated: __TIMESTAMP__", existing)
    if md_path.exists() and normalized == new_content:
        print("[PASS] Report content unchanged; preserved existing Generated timestamp.")
    else:
        stamp = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
        md_path.write_text(new_content.replace("Generated: __TIMESTAMP__", f"Generated: {stamp}", 1), encoding="utf-8")
        print("[PASS] Report content changed; refreshed Generated timestamp.")
    print(f"Generated {len(selected)} job matches")
    print(md_path)
    print(csv_path)

if __name__ == "__main__":
    run()
