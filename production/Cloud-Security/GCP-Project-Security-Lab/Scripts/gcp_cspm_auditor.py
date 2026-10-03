#!/usr/bin/env python3
"""GCP Project Configuration Security Auditor (CSPM).

Evaluates a parsed GCP project configuration snapshot (firewall rules,
storage bucket IAM/access settings, compute instance hardening, project
IAM bindings) against common cloud misconfigurations. Offline/synthetic
validation only - this analyzes a JSON configuration snapshot collected
by collect_gcp_config.py, not a live `gcloud` session.
"""
import argparse
import json
from pathlib import Path

PUBLIC_MEMBERS = {"allUsers", "allAuthenticatedUsers"}
PRIMITIVE_ROLES = {"roles/owner", "roles/editor"}


def audit_firewall_rule(rule):
    if rule.get("disabled"):
        return []
    if "0.0.0.0/0" not in (rule.get("source_ranges") or []):
        return []
    if rule.get("direction") != "INGRESS":
        return []
    if not rule.get("allowed"):
        return []
    return [{
        "check": "GCP-001",
        "finding": "Firewall rule allows ingress from 0.0.0.0/0",
        "severity": "CRITICAL",
        "detail": f"rule={rule.get('name')!r} allowed={rule.get('allowed')}",
        "mitre_attack": {"technique": "T1190", "name": "Exploit Public-Facing Application", "tactic": "Initial Access"},
    }]


def audit_bucket(bucket):
    findings = []
    name = bucket.get("name", "unknown")

    if not bucket.get("uniform_bucket_level_access"):
        findings.append({
            "check": "GCP-002",
            "finding": "Bucket does not enforce uniform bucket-level access",
            "severity": "HIGH",
            "detail": f"bucket={name!r} (per-object ACLs can bypass bucket-level IAM)",
        })

    if bucket.get("public_access_prevention") != "enforced":
        findings.append({
            "check": "GCP-003",
            "finding": "Bucket does not enforce public access prevention",
            "severity": "HIGH",
            "detail": f"bucket={name!r} public_access_prevention={bucket.get('public_access_prevention')!r}",
        })

    for binding in bucket.get("iam_bindings", []):
        public_members = [m for m in binding.get("members", []) if m in PUBLIC_MEMBERS]
        if public_members:
            findings.append({
                "check": "GCP-004",
                "finding": "Bucket IAM binding grants access to a public member",
                "severity": "CRITICAL",
                "detail": f"bucket={name!r} role={binding.get('role')!r} members={public_members}",
                "mitre_attack": {"technique": "T1530", "name": "Data from Cloud Storage", "tactic": "Collection"},
            })

    return findings


def audit_instance(instance):
    findings = []
    name = instance.get("name", "unknown")

    if instance.get("has_external_ip"):
        findings.append({
            "check": "GCP-005",
            "finding": "Instance has an external IP",
            "severity": "HIGH",
            "detail": f"instance={name!r}",
            "mitre_attack": {"technique": "T1133", "name": "External Remote Services", "tactic": "Initial Access"},
        })

    shielded_fields = ("shielded_secure_boot", "shielded_vtpm", "shielded_integrity_monitoring")
    disabled = [f for f in shielded_fields if not instance.get(f)]
    if disabled:
        findings.append({
            "check": "GCP-006",
            "finding": "Shielded VM protections not fully enabled",
            "severity": "MEDIUM",
            "detail": f"instance={name!r} disabled={disabled}",
        })

    sa_email = instance.get("service_account_email", "")
    if sa_email.split("@")[0].endswith("-compute"):
        findings.append({
            "check": "GCP-007",
            "finding": "Instance uses the default Compute Engine service account",
            "severity": "HIGH",
            "detail": f"instance={name!r} service_account={sa_email!r} (broad legacy default, prefer a scoped custom service account)",
            "mitre_attack": {"technique": "T1078.004", "name": "Valid Accounts: Cloud Accounts", "tactic": "Defense Evasion"},
        })

    return findings


def audit_project_iam(bindings):
    findings = []
    for binding in bindings:
        role = binding.get("role", "")
        if role not in PRIMITIVE_ROLES:
            continue
        public_members = [m for m in binding.get("members", []) if m in PUBLIC_MEMBERS]
        if public_members:
            findings.append({
                "check": "GCP-008",
                "finding": "Primitive role granted to a public member at the project level",
                "severity": "CRITICAL",
                "detail": f"role={role!r} members={public_members}",
                "mitre_attack": {"technique": "T1098", "name": "Account Manipulation", "tactic": "Persistence"},
            })
    return findings


def audit(config):
    findings = []

    for rule in config.get("firewall_rules", []):
        findings += audit_firewall_rule(rule)

    bucket_results = []
    for bucket in config.get("buckets", []):
        bucket_findings = audit_bucket(bucket)
        bucket_results.append({"name": bucket.get("name", "unknown"), "findings": bucket_findings})
        findings += bucket_findings

    instance_results = []
    for instance in config.get("instances", []):
        instance_findings = audit_instance(instance)
        instance_results.append({"name": instance.get("name", "unknown"), "findings": instance_findings})
        findings += instance_findings

    findings += audit_project_iam(config.get("project_iam_bindings", []))

    summary = {
        "project_id": config.get("project_id", "unknown"),
        "findings": len(findings),
        "critical": sum(1 for f in findings if f["severity"] == "CRITICAL"),
        "high": sum(1 for f in findings if f["severity"] == "HIGH"),
        "medium": sum(1 for f in findings if f["severity"] == "MEDIUM"),
    }
    return summary, findings, bucket_results, instance_results


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--input", required=True)
    p.add_argument("--output", required=True)
    args = p.parse_args()

    config = json.loads(Path(args.input).read_text())
    summary, findings, bucket_results, instance_results = audit(config)

    Path(args.output).write_text(
        json.dumps(
            {
                "summary": summary,
                "findings": findings,
                "buckets": bucket_results,
                "instances": instance_results,
            },
            indent=2,
        )
        + "\n"
    )

    print("GCP PROJECT CONFIGURATION SECURITY AUDITOR (CSPM)")
    print("=" * 60)
    print(f"Project             : {summary['project_id']}")
    print(f"Findings            : {summary['findings']}")
    for f in findings:
        print(f"{f['severity']:<9} {f['check']:<8} {f['finding']}")
    print(f"CRITICAL:{summary['critical']} HIGH:{summary['high']} MEDIUM:{summary['medium']}")
    print(f"RESULT              : COMPLETE -> {args.output}")


if __name__ == "__main__":
    main()
