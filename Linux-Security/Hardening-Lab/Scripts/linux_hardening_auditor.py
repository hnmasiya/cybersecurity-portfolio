#!/usr/bin/env python3
"""Linux Host Hardening Auditor.

Evaluates a snapshot of Linux host configuration (SSH config, sudoers
entries, file permissions, running services, firewall state) against
CIS-benchmark-style hardening rules. Offline/synthetic validation only -
this analyzes a JSON snapshot, not a live host.
"""
import argparse
import json
from pathlib import Path

RISKY_SERVICES = {"telnet", "rsh", "rlogin", "tftp", "vsftpd-anon"}


def audit_ssh_config(ssh_config):
    findings = []

    if str(ssh_config.get("PermitRootLogin", "")).lower() in ("yes", "without-password"):
        findings.append({
            "check": "SSH-001",
            "finding": "SSH root login permitted",
            "severity": "HIGH",
            "detail": f"PermitRootLogin={ssh_config.get('PermitRootLogin')}",
            "recommendation": "Set PermitRootLogin no",
        })

    if str(ssh_config.get("PasswordAuthentication", "")).lower() == "yes":
        findings.append({
            "check": "SSH-002",
            "finding": "SSH password authentication enabled",
            "severity": "MEDIUM",
            "detail": "PasswordAuthentication=yes",
            "recommendation": "Disable password auth; enforce key-based authentication",
        })

    if str(ssh_config.get("Protocol", "2")) != "2":
        findings.append({
            "check": "SSH-003",
            "finding": "Legacy SSH protocol version permitted",
            "severity": "HIGH",
            "detail": f"Protocol={ssh_config.get('Protocol')}",
            "recommendation": "Restrict to Protocol 2",
        })

    return findings


def audit_sudoers(sudoers_entries):
    findings = []
    for entry in sudoers_entries:
        if entry.get("nopasswd") and entry.get("commands") == "ALL":
            findings.append({
                "check": "SUDO-001",
                "finding": "Unrestricted passwordless sudo",
                "severity": "HIGH",
                "detail": f"user={entry.get('user')} commands=ALL NOPASSWD",
                "recommendation": "Scope sudoers entries to specific commands; require a password",
            })
    return findings


def audit_file_permissions(world_writable_files, suid_binaries, expected_suid_allowlist):
    findings = []

    for path in world_writable_files:
        if not path.startswith("/tmp") and not path.startswith("/var/tmp"):
            findings.append({
                "check": "PERM-001",
                "finding": "World-writable file outside /tmp",
                "severity": "MEDIUM",
                "detail": path,
                "recommendation": "Remove world-write permission (chmod o-w)",
            })

    for path in suid_binaries:
        if path not in expected_suid_allowlist:
            findings.append({
                "check": "PERM-002",
                "finding": "Unexpected SUID binary",
                "severity": "HIGH",
                "detail": path,
                "recommendation": "Verify necessity; remove SUID bit if unused (chmod u-s)",
            })

    return findings


def audit_services(running_services):
    findings = []
    for service in running_services:
        if service.lower() in RISKY_SERVICES:
            findings.append({
                "check": "SVC-001",
                "finding": "Legacy/insecure service running",
                "severity": "HIGH",
                "detail": service,
                "recommendation": "Disable and remove the service; use SSH/SFTP instead",
            })
    return findings


def audit_firewall(firewall_active):
    if not firewall_active:
        return [{
            "check": "FW-001",
            "finding": "Host firewall inactive",
            "severity": "MEDIUM",
            "detail": "firewall_active=false",
            "recommendation": "Enable and configure a default-deny host firewall (ufw/firewalld/nftables)",
        }]
    return []


def audit(snapshot):
    findings = []
    findings += audit_ssh_config(snapshot.get("ssh_config", {}))
    findings += audit_sudoers(snapshot.get("sudoers_entries", []))
    findings += audit_file_permissions(
        snapshot.get("world_writable_files", []),
        snapshot.get("suid_binaries", []),
        set(snapshot.get("expected_suid_allowlist", [])),
    )
    findings += audit_services(snapshot.get("running_services", []))
    findings += audit_firewall(snapshot.get("firewall_active", False))

    summary = {
        "checks_run": 5,
        "findings": len(findings),
        "high": sum(1 for f in findings if f["severity"] == "HIGH"),
        "medium": sum(1 for f in findings if f["severity"] == "MEDIUM"),
    }
    return summary, findings


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--input", required=True)
    p.add_argument("--output", required=True)
    args = p.parse_args()

    snapshot = json.loads(Path(args.input).read_text())
    summary, findings = audit(snapshot)

    Path(args.output).write_text(json.dumps({"summary": summary, "findings": findings}, indent=2) + "\n")

    print("LINUX HOST HARDENING AUDITOR")
    print("=" * 60)
    print(f"Checks run : {summary['checks_run']}")
    print(f"Findings   : {summary['findings']}")
    for f in findings:
        print(f"{f['severity']:<8} {f['check']:<8} {f['finding']:<38} {f['detail']}")
    print(f"HIGH:{summary['high']} MEDIUM:{summary['medium']}")
    print(f"RESULT     : COMPLETE -> {args.output}")


if __name__ == "__main__":
    main()
