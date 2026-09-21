from pathlib import Path
import re

SOURCE = Path("Resume_Hazvinei_Masiya.md")
OUT = Path("dist/resumes")
OUT.mkdir(parents=True, exist_ok=True)
source = SOURCE.read_text(encoding="utf-8")

variants = {
    "global": ("Global Resume", "Cybersecurity Professional | Security Operations | Detection Engineering | Automation"),
    "uk": ("UK CV", "Cybersecurity Professional | Security Operations | Detection Engineering | Automation"),
    "europe": ("European CV", "Cybersecurity Professional | Security Operations | Detection Engineering | Automation"),
    "canada": ("Canada Resume", "Cybersecurity Professional | Security Operations | Detection Engineering | Automation"),
    "united-states": ("US Resume", "Cybersecurity Professional | Security Operations | Detection Engineering | Automation"),
    "australia-new-zealand": ("Australia / New Zealand Resume", "Cybersecurity Professional | Security Operations | Detection Engineering | Automation"),
    "middle-east": ("Middle East Resume", "Cybersecurity Professional | Security Operations | Detection Engineering | Automation"),
    "africa": ("Africa Resume", "Cybersecurity Professional | Security Operations | Detection Engineering | Automation"),
    "asia-pacific": ("Asia-Pacific Resume", "Cybersecurity Professional | Security Operations | Detection Engineering | Automation"),
}

for slug, (label, subtitle) in variants.items():
    text = source
    text = re.sub(r'<div class="subtitle">.*?</div>', f'<div class="subtitle">{subtitle}</div>', text, count=1, flags=re.S)
    text = text.replace(
        '<div class="availability">Global opportunities: Remote · Hybrid · On-site · Relocation</div>',
        f'<div class="availability">{label} · Remote · Hybrid · On-site · Relocation</div>',
        1,
    )
    text = text.replace("Global Application Profile", f"{label} Application Profile", 1)
    (OUT / f"{slug}.md").write_text(text, encoding="utf-8")

print(f"Generated {len(variants)} resume source variants in {OUT}")
