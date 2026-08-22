#!/usr/bin/env python3
import os
import subprocess
import sys

def run_cmd(cmd):
    result = subprocess.run(cmd, shell=True, text=True, capture_output=True)
    if result.returncode != 0:
        print(f"[-] Error executing: {cmd}")
        print(result.stderr)
        sys.exit(1)
    return result.stdout.strip()

def main():
    print("==========================================================================")
    print("           AUTOMATED CYBERSECURITY LAB COMMIT & CI/CD TRIGGER             ")
    print("==========================================================================")
    
    lab_name = input("[?] Enter Lab Name / Focus (e.g., Wazuh Lateral Movement Detection): ").strip()
    if not lab_name:
        print("[-] Lab name cannot be empty.")
        sys.exit(1)

    mitre_id = input("[?] Enter MITRE ATT&CK Technique ID (e.g., T1110.001) [Optional]: ").strip()
    
    commit_type = input("[?] Commit Type (lab / feat / docs / fix) [default: lab]: ").strip().lower() or "lab"
    
    # Format Commit Message
    if mitre_id:
        commit_msg = f"{commit_type}: {lab_name} [{mitre_id}]"
    else:
        commit_msg = f"{commit_type}: {lab_name}"

    print("\n[*] Staging all changes...")
    run_cmd("git add .")

    print(f"[*] Executing commit: '{commit_msg}'...")
    print("[*] Pre-commit hook active: Sanitizing raw logs in evidence-logs/...")
    commit_output = run_cmd(f'git commit -m "{commit_msg}"')
    print(commit_output)

    print("\n[*] Pushing to origin/main to trigger automated DevSecOps pipelines...")
    push_output = run_cmd("git push origin main")
    print(push_output)

    print("\n[+] SUCCESS! Lab committed and pushed.")
    print("[+] CI/CD Pipelines triggered on GitHub Actions:")
    print("    - TruffleHog Secret Scanning")
    print("    - Bandit / Yamllint SAST")
    print("    - Dynamic README Activity Updater")
    print("    - Portfolio System Audit")

if __name__ == "__main__":
    main()
