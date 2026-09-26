#!/usr/bin/env python3
"""Evidence-safe ATS readiness validator.

This is a deterministic quality gate, not a prediction of employer ATS ranking
or hiring outcome. It reads only the supplied resume and job posting.
"""
import argparse
import re
from pathlib import Path

def text(path: str) -> str:
    return Path(path).read_text(encoding="utf-8", errors="ignore")

def words(value: str) -> set[str]:
    return set(re.findall(r"[a-z0-9][a-z0-9+#./-]{2,}", value.lower()))

def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--job", required=True)
    parser.add_argument("--resume", required=True)
    parser.add_argument("--required", default="")
    parser.add_argument("--out", required=True)
    args = parser.parse_args()

    job = text(args.job)
    resume = text(args.resume)
    required = [x.strip().lower() for x in args.required.split(",") if x.strip()]
    missing = [x for x in required if x not in resume.lower()]

    checks = [
        ("Resume is readable", bool(resume.strip())),
        ("Required supplied terms are present", not missing),
        ("Security role alignment", any(x in resume.lower() for x in ("cybersecurity","security","soc","information security","security operations"))),
        ("Security certification evidence", any(x in resume.lower() for x in ("security+","google cybersecurity","google it support"))),
        ("Unsupported-claim guard", not any(x in resume.lower() for x in ("guaranteed","expert in all","100% success"))),
        ("Job posting supplied", bool(words(job))),
    ]
    status = "PASS" if all(ok for _, ok in checks) else "NEEDS REVISION"

    out = Path(args.out)
    out.parent.mkdir(parents=True, exist_ok=True)
    lines = [
        "# ATS Readiness",
        f"Status: **{status}**",
        "",
        "> Deterministic internal quality gate only; this does not guarantee ATS acceptance, ranking or selection.",
        "",
    ]
    lines.extend(f"- {'PASS' if ok else 'NEEDS REVISION'} — {name}" for name, ok in checks)
    if missing:
        lines += ["", "Missing required supplied terms:", *[f"- {item}" for item in missing]]
    out.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(status)
    return 0 if status == "PASS" else 2

if __name__ == "__main__":
    raise SystemExit(main())
