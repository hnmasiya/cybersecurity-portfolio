#!/usr/bin/env python3
"""Build country-aware resume sources from one verified master resume.

Country profiles control presentation only. They never invent nationality,
work authorization, local residence, salary, clearance, employment or other
claims. Unknown countries fall back to an international A4 profile.
"""
from pathlib import Path
import json
import re

ROOT=Path(__file__).resolve().parents[1]
SOURCE=ROOT/"Resume_Hazvinei_Masiya.md"
PROFILES=ROOT/"resume-variants/country-profiles.json"
OUT=ROOT/"dist/resumes"
source=SOURCE.read_text(encoding="utf-8")
profiles=json.loads(PROFILES.read_text(encoding="utf-8"))
OUT.mkdir(parents=True,exist_ok=True)

regional={
 "europe":{"label":"European CV","page_size":"A4"},
 "africa":{"label":"African CV","page_size":"A4"},
 "middle-east":{"label":"Middle East Resume","page_size":"A4"},
 "asia-pacific":{"label":"Asia-Pacific Resume","page_size":"A4"},
 "international":{"label":"International Resume","page_size":"A4"},
}
region_codes={
 "europe":"AL AD AT BE BG HR CY CZ DK EE FI GR HU IS IT LV LI LT LU MT MC ME NO PL PT RO SM RS SK SI ES SE UA VA",
 "africa":"DZ AO BW CM EG ET GH KE MW MZ NA RW SN TZ UG ZM ZW ZA NG",
 "middle-east":"BH IL JO KW LB OM QA SA AE",
 "asia-pacific":"BD CN HK ID JP KH KR LK MY MM NP PH PK SG TH TW VN AU NZ",
}
region_codes={k:set(v.split()) for k,v in region_codes.items()}

def slug(value):
    return re.sub(r"[^a-z0-9]+","-",value.lower()).strip("-")

targets={}
for code,profile in profiles.items():
    if code!="default":
        targets[code]=profile
for key,p in regional.items():
    targets[key.upper()]=p

for key,profile in targets.items():
    label=profile["label"]
    page=profile.get("page_size","A4")
    margin="0.45in 0.55in" if page=="A4" else "0.42in 0.55in"
    text=source
    text=re.sub(r"@page\s*\{[^}]*\}",
                f"@page {{ size: {page}; margin: {margin}; }}",
                text,count=1,flags=re.S)
    text=re.sub(r"<h2>Global Application Profile</h2>.*?<h2>Core Competencies & Technical Stack</h2>",
                "<h2>Core Competencies & Technical Stack</h2>",
                text,count=1,flags=re.S)
    text=text.replace("Global opportunities: Remote · Hybrid · On-site · Relocation",
                      "Remote · Hybrid · On-site · Relocation",1)
    text=text.replace("<!-- Single cybersecurity-first resume source. Global master template for country-specific variants. -->",
                      f"<!-- Country profile: {label}. Generated from the verified master resume. -->",1)
    (OUT/f"{slug(label)}.md").write_text(text,encoding="utf-8")

print(f"Generated {len(targets)} country/regional resume sources in {OUT}")
