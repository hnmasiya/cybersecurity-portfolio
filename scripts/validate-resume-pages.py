#!/usr/bin/env python3
"""Strict resume PDF quality gate: every published variant must be exactly 2 pages."""
import argparse
import subprocess
from pathlib import Path

def pages(pdf: Path) -> int:
    result = subprocess.run(["pdfinfo", str(pdf)], text=True, capture_output=True, check=True)
    for line in result.stdout.splitlines():
        if line.startswith("Pages:"):
            return int(line.split(":",1)[1].strip())
    raise RuntimeError(f"Unable to read page count from {pdf}")

def main():
    p=argparse.ArgumentParser()
    p.add_argument("directory",type=Path)
    p.add_argument("--expected",type=int,default=2)
    a=p.parse_args()
    pdfs=sorted(a.directory.glob("*.pdf"))
    if not pdfs:
        print("[FAIL] No resume PDFs found."); return 1
    failed=[]
    for pdf in pdfs:
        count=pages(pdf)
        ok=count==a.expected
        print(f"[{'PASS' if ok else 'FAIL'}] {pdf.name}: {count} page(s)")
        if not ok: failed.append((pdf.name,count))
    if failed:
        print("\n[FAIL] Every published resume must be exactly 2 pages.")
        return 2
    print(f"\n[PASS] {len(pdfs)} resume PDFs validated at exactly {a.expected} pages.")
    return 0
if __name__=="__main__":
    raise SystemExit(main())
