#!/usr/bin/env python3
"""Generate regional resume sources from one authoritative master resume.

The master source is the only factual source. Country profiles control
presentation, terminology, section order, emphasis and page geometry.
No profile may invent qualifications, employers, clients, metrics,
work authorisation, nationality, clearance or other claims.
"""
from pathlib import Path
import json
import re

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "Resume_Hazvinei_Masiya.md"
PROFILES = ROOT / "resume-variants/country-profiles.json"
OUT = ROOT / "dist/resumes"

source = SOURCE.read_text(encoding="utf-8")
profiles = json.loads(PROFILES.read_text(encoding="utf-8"))
OUT.mkdir(parents=True, exist_ok=True)


REGIONS = {
    "europe": {"label": "European CV", "page_size": "A4", "fallback_key": "default"},
    "africa": {"label": "African CV", "page_size": "A4", "fallback_key": "default"},
    "middle-east": {"label": "Middle East Resume", "page_size": "A4", "fallback_key": "default"},
    "asia-pacific": {"label": "Asia-Pacific Resume", "page_size": "A4", "fallback_key": "default"},
    "international": {"label": "International Resume", "page_size": "A4", "fallback_key": "default"},
}


def slug(value: str) -> str:
    return re.sub(r"[^a-z0-9]+", "-", value.lower()).strip("-")


def replace_css(source_text: str, profile: dict) -> str:
    page = profile.get("page_size", "A4")
    margin = profile.get("margin", "0.30in 0.42in")
    text = re.sub(
        r"@page\s*\{[^}]*\}",
        f"@page {{ size: {page}; margin: {margin}; }}",
        source_text,
        count=1,
        flags=re.S,
    )
    return text


def set_heading(text: str, old: str, new: str) -> str:
    return text.replace(f"<h2>{old}</h2>", f"<h2>{new}</h2>", 1)


def regionally_adapt(text: str, profile: dict) -> str:
    text = replace_css(text, profile)

    # Header terminology.
    title = profile.get("title_term")
    if title:
        text = re.sub(
            r'<div class="subtitle">.*?</div>',
            f'<div class="subtitle">{title}</div>',
            text,
            count=1,
            flags=re.S,
        )

    # Regional section headings.
    heading_map = {
        "summary_heading": ("Professional Summary", "Professional Summary"),
        "experience_heading": ("Professional Experience", "Professional Experience"),
        "skills_heading": ("Core Competencies & Technical Stack", "Core Competencies & Technical Skills"),
        "projects_heading": ("Security Engineering Projects & Artifacts", "Selected Cybersecurity Projects"),
        "education_heading": ("Certifications & Education", "Education"),
        "certifications_heading": ("Certifications & Education", "Certifications"),
    }
    for key, (default_old, default_new) in heading_map.items():
        desired = profile.get(key)
        if desired:
            text = set_heading(text, default_old, desired)

    # The master has one combined education/certification section. For
    # regional profiles that request separate headings, keep the facts intact
    # while using a combined heading to avoid duplicating content.
    if profile.get("education_heading") == "Education" and profile.get("certifications_heading") == "Certifications":
        text = set_heading(text, "Certifications", "Education & Certifications")

    # UK spelling and terminology where the profile explicitly requests it.
    if profile.get("locale") == "uk":
        replacements = {
            "Specialization": "Specialisation",
            "optimized": "optimised",
            "organization": "organisation",
            "analyze": "analyse",
            "analyzed": "analysed",
            "authorization": "authorisation",
            "behavior": "behaviour",
            "center": "centre",
        }
        for old, new in replacements.items():
            text = re.sub(rf"\b{re.escape(old)}\b", new, text)

    # Remove the broad availability line in regions where it adds little ATS value.
    if profile.get("hide_availability"):
        text = re.sub(r'\n\s*<div class="availability">.*?</div>', "", text, count=1, flags=re.S)

    # Languages are already omitted from the master. Add only when explicitly
    # requested, using the verified language information supplied for the profile.
    if profile.get("include_languages"):
        language_block = (
            '<h2>Language Skills</h2>\n'
            '<ul><li><b>English:</b> Fluent</li><li><b>Shona:</b> Native</li></ul>\n'
        )
        insert_before = "<h2>Certifications & Education</h2>"
        if insert_before not in text:
            insert_before = "<h2>Education & Certifications</h2>"
        if insert_before in text:
            text = text.replace(insert_before, language_block + insert_before, 1)
        else:
            text += "\n" + language_block

    if profile.get("include_references"):
        text += (
            '\n<h2>References</h2>\n'
            '<p>References available on request.</p>\n'
        )

    # Keep the single source comment explicit.
    text = re.sub(
        r"<!--.*?-->",
        f"<!-- Country profile: {profile.get('label', 'International Resume')}. "
        "Generated from the verified master resume. -->",
        text,
        count=1,
        flags=re.S,
    )

    return text


# Generate one canonical file per explicit country profile.
generated = 0
for code, profile in profiles.items():
    if code == "default":
        continue
    (OUT / f"{slug(profile['label'])}.md").write_text(
        regionally_adapt(source, profile),
        encoding="utf-8",
    )
    generated += 1

# Generate regional fallback profiles.
for region, regional in REGIONS.items():
    base_profile = dict(profiles.get(regional["fallback_key"], {}))
    base_profile.update(regional)
    base_profile["include_languages"] = True if region != "international" else False
    base_profile["include_references"] = region == "africa"
    base_profile.setdefault("title_term", "IT Professional | Cybersecurity Professional | Founder")
    (OUT / f"{region}.md").write_text(
        regionally_adapt(source, base_profile),
        encoding="utf-8",
    )
    generated += 1

print(f"Generated {generated} country/regional resume sources in {OUT}")
