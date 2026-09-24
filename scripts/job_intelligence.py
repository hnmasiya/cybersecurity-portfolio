#!/usr/bin/env python3
import csv
import json
import re
from datetime import datetime, timezone
from pathlib import Path
from urllib.request import Request, urlopen

ROOT = Path(__file__).resolve().parents[1]
CONFIG = json.loads((ROOT / "career/job-search-config.json").read_text(encoding="utf-8"))
OUT = ROOT / "career/reports"
OUT.mkdir(parents=True, exist_ok=True)


def fetch_json(url):
    req = Request(url, headers={"User-Agent": "hnmasiya-career-intelligence/2.0"})
    with urlopen(req, timeout=30) as r:
        return json.loads(r.read().decode("utf-8"))


def norm(x):
    return re.sub(r"\s+", " ", str(x or "")).strip()


def contains_term(text, term):
    text = text.lower()
    term = norm(term).lower()
    if not term:
        return False
    # Avoid substring false positives for short tokens such as SOC, IAM, and GRC.
    if re.fullmatch(r"[a-z0-9]+", term) and len(term) <= 4:
        return bool(re.search(rf"\b{re.escape(term)}\b", text))
    return term in text


def find_terms(text, terms):
    return [term for term in terms if contains_term(text, term)]


def score(job):
    title = norm(job.get("title")).lower()
    body = norm(" ".join([
        job.get("description", ""),
        job.get("category", ""),
        job.get("tags", ""),
    ])).lower()

    filters = CONFIG["filters"]
    title_hits = find_terms(title, filters.get("title_include_terms", []))
    blocked = find_terms(title, filters.get("title_block_terms", []))
    excluded = find_terms(title, filters.get("title_exclude_terms", []))

    # Allow technical titles such as "Backend Engineer (Security)" when the
    # security qualifier is in the title, while still rejecting non-technical
    # sales/product/business roles containing the word "security".
    technical_title_terms = (
        "engineer", "developer", "architect", "analyst", "administrator",
        "consultant", "specialist", "researcher", "tester", "operations"
    )
    security_qualified_technical = (
        contains_term(title, "security")
        and any(contains_term(title, term) for term in technical_title_terms)
    )
    if security_qualified_technical:
        title_hits.append("security")

    # Require a security-specific title signal. This prevents generic roles from
    # qualifying merely because their description mentions a security responsibility.
    if blocked or excluded or not title_hits:
        return None

    context_hits = find_terms(
        " ".join([title, body]),
        filters.get("context_include_terms", [])
    )

    # Strong title relevance carries most of the score; context terms refine ordering.
    match_score = len(title_hits) * 10 + min(len(context_hits), 8) * 2
    matched = title_hits + [x for x in context_hits if x not in title_hits]
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


def dedupe_key(job):
    parts = [job.get("title", ""), job.get("company", ""), job.get("location", "")]
    return "||".join(re.sub(r"[^a-z0-9]+", " ", norm(x).lower()).strip() for x in parts)


def run():
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
        if previous is None or (job["match_score"], job.get("published", "")) > (previous["match_score"], previous.get("published", "")):
            unique[key] = job

    selected = sorted(
        unique.values(),
        key=lambda x: (-x["match_score"], x["title"].lower(), x["company"].lower())
    )[:CONFIG["filters"]["max_results"]]

    stamp = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    date = datetime.now(timezone.utc).strftime("%Y-%m-%d")

    csv_path = OUT / f"jobs-{date}.csv"
    with csv_path.open("w", newline="", encoding="utf-8") as f:
        fields = ["match_score", "title", "company", "location", "remote", "source", "published", "url", "matched_terms"]
        w = csv.DictWriter(f, fieldnames=fields)
        w.writeheader()
        for job in selected:
            row = {k: job.get(k, "") for k in fields}
            row["matched_terms"] = ", ".join(job["matched_terms"])
            w.writerow(row)

    md_path = OUT / f"jobs-{date}.md"
    lines = [
        f"# Cybersecurity Job Intelligence — {date}",
        "",
        f"Generated: {stamp}",
        "",
        "Discovery results only. Verify the original employer/ATS posting before applying.",
        "",
        "Strict relevance filter: a security-specific signal must appear in the job title; generic roles do not qualify from description-only keyword matches.",
        "",
    ]
    if errors:
        lines += ["## Source warnings", ""] + [f"- {e}" for e in errors] + [""]

    for i, job in enumerate(selected, 1):
        lines += [
            f"## {i}. {job['title']}",
            f"- **Company:** {job['company'] or 'Not stated'}",
            f"- **Location:** {job['location'] or 'Not stated'}",
            f"- **Remote:** {job['remote'] or 'Not stated'}",
            f"- **Match signals:** {', '.join(job['matched_terms'])}",
            f"- **Source:** {job['source']}",
            f"- **Job:** {job['url']}",
            "",
        ]
    md_path.write_text("\n".join(lines), encoding="utf-8")
    print(f"Generated {len(selected)} job matches")
    print(md_path)
    print(csv_path)


if __name__ == "__main__":
    run()
