from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]

IGNORE_PARTS = {
    ".git",
    "Archive",
}

PLACEHOLDER_RE = re.compile(
    r"VERIFICATION REQUIRED|PLACEHOLDER|TODO|TBD|should be merged|Original Write-Up",
    re.I,
)

SECRET_RE = re.compile(
    r"(INDEXER_PASSWORD=|API_PASSWORD=|DASHBOARD_PASSWORD=)",
    re.I,
)


def scan(root):
    """Walk root and return a dict of findings: broken_links, broken_images,
    placeholders, secrets, runtime (all lists of strings)."""
    broken_links = []
    broken_images = []
    placeholders = []
    secrets = []
    runtime = []

    for p in root.rglob("*"):
        if not p.is_file():
            continue
        if any(part in IGNORE_PARTS for part in p.parts):
            continue

        if "__pycache__" in p.parts or p.suffix in {".pyc", ".pyo"}:
            runtime.append(str(p.relative_to(root)))

        if p.suffix.lower() != ".md":
            continue

        text = p.read_text(errors="ignore")

        if PLACEHOLDER_RE.search(text):
            placeholders.append(str(p.relative_to(root)))

        if SECRET_RE.search(text):
            secrets.append(str(p.relative_to(root)))

        for link in re.findall(r"(?<!!)\[[^\]]+\]\(([^)]+)\)", text):
            if link.startswith(("http://", "https://", "#", "mailto:")):
                continue
            target = (p.parent / link.split("#")[0]).resolve()
            if not target.exists():
                broken_links.append(f"{p.relative_to(root)} -> {link}")

        for link in re.findall(r"!\[[^\]]*\]\(([^)]+)\)", text):
            if link.startswith(("http://", "https://", "#")):
                continue
            target = (p.parent / link.split("#")[0]).resolve()
            if not target.exists():
                broken_images.append(f"{p.relative_to(root)} -> {link}")

    return {
        "broken_links": broken_links,
        "broken_images": broken_images,
        "placeholders": placeholders,
        "secrets": secrets,
        "runtime": runtime,
    }


def main():
    findings = scan(ROOT)
    broken_links = findings["broken_links"]
    broken_images = findings["broken_images"]
    placeholders = findings["placeholders"]
    secrets = findings["secrets"]
    runtime = findings["runtime"]

    print("=" * 70)
    print(" PORTFOLIO QUALITY CHECK ")
    print("=" * 70)
    print(f"Broken local links : {len(broken_links)}")
    print(f"Broken image refs  : {len(broken_images)}")
    print(f"Placeholder files  : {len(placeholders)}")
    print(f"Secret-pattern docs: {len(secrets)}")
    print(f"Runtime artifacts  : {len(runtime)}")

    for title, items in (
        ("BROKEN LINKS", broken_links),
        ("BROKEN IMAGES", broken_images),
        ("PLACEHOLDERS", placeholders),
        ("SECRET PATTERNS", secrets),
        ("RUNTIME ARTIFACTS", runtime),
    ):
        if items:
            print(f"\n{title}:")
            for item in items[:30]:
                print(f"  {item}")

    # Runtime artifacts and secrets are hard failures.
    # Existing placeholder text is reported for review rather than used
    # as a blanket failure because archived/materialized methodology files
    # may intentionally contain evidence-bound language.
    if broken_links or broken_images or runtime or secrets:
        return 1

    print("\nRESULT: PASS")
    return 0


if __name__ == "__main__":
    sys.exit(main())
