#!/usr/bin/env python3
import argparse
import hashlib
import json
from pathlib import Path
from datetime import datetime, timezone

def sha256_file(path):
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()

def hashes(target):
    return {
        str(p.relative_to(target)): sha256_file(p)
        for p in sorted(target.rglob("*"))
        if p.is_file()
    }

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--target", required=True)
    parser.add_argument("--state", required=True)
    args = parser.parse_args()

    target = Path(args.target).resolve()
    state = Path(args.state).resolve()

    if not target.is_dir():
        raise SystemExit(f"ERROR: target does not exist: {target}")

    state.parent.mkdir(parents=True, exist_ok=True)
    current = hashes(target)
    now = datetime.now(timezone.utc).isoformat()

    if not state.exists():
        state.write_text(json.dumps({
            "created": now,
            "updated": now,
            "files": current
        }, indent=2) + "\n")
        print("BASELINE CREATED")
        print(f"Files: {len(current)}")
        print(f"State: {state}")
        return

    old_data = json.loads(state.read_text())
    old = old_data.get("files", {})

    added = sorted(set(current) - set(old))
    removed = sorted(set(old) - set(current))
    modified = sorted(
        k for k in set(current) & set(old)
        if current[k] != old[k]
    )

    print("FILE INTEGRITY CHECK")
    print(f"Files: {len(current)}")

    for item in added:
        print(f"ADDED    : {item}")

    for item in removed:
        print(f"REMOVED  : {item}")

    for item in modified:
        print(f"MODIFIED : {item}")

    if not added and not removed and not modified:
        print("RESULT   : NO CHANGES DETECTED")
    else:
        print("RESULT   : CHANGES DETECTED")

    state.write_text(json.dumps({
        "created": old_data.get("created", now),
        "updated": now,
        "files": current
    }, indent=2) + "\n")

if __name__ == "__main__":
    main()
