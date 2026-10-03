#!/usr/bin/env python3
import datetime
import subprocess
import sys

def run_cmd(cmd):
    result = subprocess.run(cmd, shell=False, text=True, capture_output=True)
    if result.returncode != 0:
        print(f"[-] Error executing: {' '.join(cmd)}")
        print(result.stderr)
        sys.exit(1)
    return result.stdout.strip()

def main():
    # Check if there are changes to commit
    status = run_cmd(["git", "status", "--porcelain"])
    if not status:
        print("[+] Working tree clean. Nothing to commit.")
        sys.exit(0)

    # Auto-generate timestamped commit message
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
    commit_msg = f"lab: automated portfolio update [{timestamp}]"

    print("[*] Pulling latest remote changes (--rebase)...")
    run_cmd(["git", "pull", "--rebase", "origin", "main"])

    print("[*] Staging all files...")
    run_cmd(["git", "add", "."])

    print(f"[*] Committing: '{commit_msg}'...")
    print("[*] Running local pre-commit log sanitizer...")
    commit_output = run_cmd(["git", "commit", "-m", commit_msg])
    print(commit_output)

    print("[*] Pushing to origin/main...")
    push_output = run_cmd(["git", "push", "origin", "main"])
    print(push_output)

    print("\n[+] SUCCESS! All changes committed and pushed automatically.")

if __name__ == "__main__":
    main()
