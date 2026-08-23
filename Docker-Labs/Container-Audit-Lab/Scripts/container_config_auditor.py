#!/usr/bin/env python3
"""Container Configuration Security Auditor.

Evaluates parsed container build/runtime configuration (image tag, user,
environment variables, privileged mode, network mode, volume mounts)
against common container security misconfigurations. Offline/synthetic
validation only - this analyzes a JSON configuration snapshot, not a
live Docker daemon.
"""
import argparse
import json
import re
from pathlib import Path

SECRET_KEY_RE = re.compile(r"(?i)^(.*_)?(api[_-]?key|token|secret|password|private[_-]?key)(_.*)?$")
PLACEHOLDER_VALUES = {"", "changeme", "redacted", "example", "xxxxx", "your-secret-here"}


def audit_user(container):
    user = container.get("user")
    if not user or user == "root":
        return [{
            "check": "CTR-001",
            "finding": "Container runs as root",
            "severity": "HIGH",
            "detail": f"user={user!r}",
            "mitre_attack": {"technique": "T1611", "name": "Escape to Host", "tactic": "Privilege Escalation"},
        }]
    return []


def audit_image_tag(container):
    image = container.get("image", "")
    tag = image.split(":")[1] if ":" in image else "latest"
    if tag == "latest":
        return [{
            "check": "CTR-002",
            "finding": "Unpinned base image tag",
            "severity": "MEDIUM",
            "detail": f"image={image!r}",
        }]
    return []


def audit_secrets(container):
    findings = []
    for key, value in container.get("env", {}).items():
        if SECRET_KEY_RE.match(key) and str(value).lower() not in PLACEHOLDER_VALUES:
            findings.append({
                "check": "CTR-003",
                "finding": "Hardcoded secret in environment variable",
                "severity": "HIGH",
                "detail": f"env.{key}",
                "mitre_attack": {"technique": "T1552.001", "name": "Credentials In Files", "tactic": "Credential Access"},
            })
    return findings


def audit_privileged(container):
    if container.get("privileged"):
        return [{
            "check": "CTR-004",
            "finding": "Container running in privileged mode",
            "severity": "CRITICAL",
            "detail": "privileged=true",
            "mitre_attack": {"technique": "T1611", "name": "Escape to Host", "tactic": "Privilege Escalation"},
        }]
    return []


def audit_docker_socket(container):
    for volume in container.get("volumes", []):
        if "docker.sock" in volume:
            return [{
                "check": "CTR-005",
                "finding": "Docker socket mounted into container",
                "severity": "CRITICAL",
                "detail": volume,
                "mitre_attack": {"technique": "T1611", "name": "Escape to Host", "tactic": "Privilege Escalation"},
            }]
    return []


def audit_network_mode(container):
    if container.get("network_mode") == "host":
        return [{
            "check": "CTR-006",
            "finding": "Container using host network mode",
            "severity": "MEDIUM",
            "detail": "network_mode=host",
        }]
    return []


def audit_container(container):
    findings = []
    findings += audit_user(container)
    findings += audit_image_tag(container)
    findings += audit_secrets(container)
    findings += audit_privileged(container)
    findings += audit_docker_socket(container)
    findings += audit_network_mode(container)
    return findings


def audit(containers):
    results = []
    for container in containers:
        findings = audit_container(container)
        results.append({"name": container.get("name", "unknown"), "findings": findings})

    all_findings = [f for r in results for f in r["findings"]]
    summary = {
        "containers_analyzed": len(containers),
        "findings": len(all_findings),
        "critical": sum(1 for f in all_findings if f["severity"] == "CRITICAL"),
        "high": sum(1 for f in all_findings if f["severity"] == "HIGH"),
        "medium": sum(1 for f in all_findings if f["severity"] == "MEDIUM"),
    }
    return summary, results


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--input", required=True)
    p.add_argument("--output", required=True)
    args = p.parse_args()

    containers = json.loads(Path(args.input).read_text())
    summary, results = audit(containers)

    Path(args.output).write_text(json.dumps({"summary": summary, "results": results}, indent=2) + "\n")

    print("CONTAINER CONFIGURATION SECURITY AUDITOR")
    print("=" * 60)
    print(f"Containers analyzed : {summary['containers_analyzed']}")
    print(f"Findings            : {summary['findings']}")
    for r in results:
        for f in r["findings"]:
            print(f"{f['severity']:<9} {r['name']:<12} {f['check']:<8} {f['finding']}")
    print(f"CRITICAL:{summary['critical']} HIGH:{summary['high']} MEDIUM:{summary['medium']}")
    print(f"RESULT              : COMPLETE -> {args.output}")


if __name__ == "__main__":
    main()
