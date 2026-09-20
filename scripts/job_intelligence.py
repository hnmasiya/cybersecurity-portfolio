#!/usr/bin/env python3
import csv, json, os, re
from datetime import datetime, timezone
from pathlib import Path
from urllib.request import Request, urlopen

ROOT=Path(__file__).resolve().parents[1]
CONFIG=json.loads((ROOT/"career/job-search-config.json").read_text())
OUT=ROOT/"career/reports"; OUT.mkdir(parents=True,exist_ok=True)

def fetch(url):
    req=Request(url,headers={"User-Agent":"hnmasiya-career-intelligence/1.0"})
    with urlopen(req,timeout=30) as r: return json.loads(r.read().decode())

def norm(x): return re.sub(r"\s+"," ",str(x or "")).strip()

def score(j):
    text=norm(" ".join([j.get("title",""),j.get("description",""),j.get("location","")])).lower()
    inc=[x.lower() for x in CONFIG["filters"]["include_terms"]]
    exc=[x.lower() for x in CONFIG["filters"]["exclude_terms"]]
    hits=[x for x in inc if x in text]; bad=[x for x in exc if x in text]
    role=35 if any(x in text for x in ["soc analyst","security analyst","cybersecurity analyst","security operations"]) else 15
    skill=min(35,len(hits)*5)
    region=10 if any(r.lower() in text for rs in CONFIG["regions"].values() for r in rs) or j.get("remote") else 0
    freshness=10 if j.get("published") else 0
    return max(0,min(100,role+skill+region+freshness-len(bad)*20)),hits,bad

jobs=[]; errors=[]
for s in CONFIG["sources"]:
    try:
        typ=s["type"]
        if typ=="arbeitnow" or typ=="remotive":
            d=fetch(s["url"])
            items=d.get("data",[]) if typ=="arbeitnow" else d.get("jobs",[])
            for x in items:
                jobs.append({"title":norm(x.get("title")),"company":norm(x.get("company_name")),"location":norm(x.get("location") if typ=="arbeitnow" else x.get("candidate_required_location")),"remote":str(x.get("remote","")),"url":x.get("url",""),"description":norm(x.get("description")),"source":s["name"],"published":x.get("created_at" if typ=="arbeitnow" else "publication_date","")})
        elif typ=="greenhouse":
            tokens=[x.strip() for x in os.getenv("GREENHOUSE_BOARD_TOKENS","").split(",") if x.strip()]
            for token in tokens:
                d=fetch(s["url"].format(board_token=token))
                for x in d.get("jobs",[]):
                    jobs.append({"title":norm(x.get("title")),"company":s["name"],"location":norm((x.get("location") or {}).get("name")),"remote":"","url":x.get("absolute_url",""),"description":norm(x.get("content")),"source":s["name"],"published":x.get("updated_at","")})
        elif typ=="adzuna":
            aid=os.getenv("ADZUNA_APP_ID"); key=os.getenv("ADZUNA_APP_KEY")
            if not aid or not key: errors.append("Adzuna: API credentials not configured"); continue
            for country in ["us","ca","mx","gb","de","fr","nl","au","nz","za","ae","ie","es","it","se"]:
                d=fetch(s["url"].format(country=country)+f"?app_id={aid}&app_key={key}&results_per_page=50&what=cybersecurity")
                for x in d.get("results",[]):
                    jobs.append({"title":norm(x.get("title")),"company":norm((x.get("company") or {}).get("display_name")),"location":norm((x.get("location") or {}).get("display_name")),"remote":"","url":x.get("redirect_url",""),"description":norm(x.get("description")),"source":s["name"],"published":x.get("created","")})
    except Exception as e: errors.append(f'{s["name"]}: {e}')

unique={}
for j in jobs:
    if not j["url"]: continue
    sc,hits,bad=score(j)
    if bad or sc<CONFIG["filters"]["high_relevance_threshold"]: continue
    j["match_score"]=sc; j["matched_terms"]=hits; unique[j["url"]]=j
selected=sorted(unique.values(),key=lambda x:(-x["match_score"],x["title"]))[:CONFIG["filters"]["max_results"]]
date=datetime.now(timezone.utc).strftime("%Y-%m-%d"); stamp=datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
csvp=OUT/f"jobs-{date}.csv"
fields=["match_score","title","company","location","remote","source","published","url","matched_terms"]
with csvp.open("w",newline="",encoding="utf-8") as f:
    w=csv.DictWriter(f,fieldnames=fields); w.writeheader()
    for j in selected: w.writerow({**j,"matched_terms":", ".join(j["matched_terms"])})
md=OUT/f"jobs-{date}.md"; lines=[f"# Cybersecurity Job Intelligence — {date}","",f"Generated: {stamp}","","High-relevance discovery results. Verify the original employer/ATS posting before applying.",""]
if errors: lines+=["## Source warnings",""]+[f"- {e}" for e in errors]+[""]
for i,j in enumerate(selected,1): lines += [f"## {i}. {j['title']}",f"- Company: {j['company'] or 'Not stated'}",f"- Location: {j['location'] or 'Not stated'}",f"- Match score: {j['match_score']}",f"- Source: {j['source']}",f"- Job: {j['url']}",""]
md.write_text("\n".join(lines),encoding="utf-8")
print(f"Generated {len(selected)} high-relevance job matches")
