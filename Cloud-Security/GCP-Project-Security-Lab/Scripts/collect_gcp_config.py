#!/usr/bin/env python3
"""Collects real GCP project configuration via `gcloud`, transformed into
the JSON schema gcp_cspm_auditor.py expects.

Requires an authenticated `gcloud` CLI (`gcloud auth login` /
`gcloud auth application-default login`) with at least Viewer access on
the target project. Nothing here modifies project state - every call is
a read-only `list`/`describe`/`get-iam-policy`.

Usage: python3 collect_gcp_config.py --project YOUR_PROJECT_ID > gcp_config.json
"""
import argparse
import json
import subprocess
import sys


def run_gcloud(args):
    result = subprocess.run(
        ["gcloud", *args, "--format=json"], capture_output=True, text=True
    )
    if result.returncode != 0:
        print(f"warning: gcloud {' '.join(args)} failed: {result.stderr.strip()}", file=sys.stderr)
        return []
    return json.loads(result.stdout) if result.stdout.strip() else []


def collect_firewall_rules(project):
    rules = run_gcloud(["compute", "firewall-rules", "list", "--project", project])
    return [
        {
            "name": r.get("name", ""),
            "direction": r.get("direction", ""),
            "disabled": bool(r.get("disabled", False)),
            "source_ranges": r.get("sourceRanges", []) or [],
            "allowed": [
                {"protocol": a.get("IPProtocol", ""), "ports": a.get("ports", [])}
                for a in r.get("allowed", []) or []
            ],
        }
        for r in rules
    ]


def collect_buckets(project):
    buckets = run_gcloud(["storage", "buckets", "list", "--project", project])
    results = []
    for b in buckets:
        name = (b.get("name") or b.get("id") or "").rstrip("/")
        if name.startswith("gs://"):
            name = name[len("gs://") :]
        iam = run_gcloud(["storage", "buckets", "get-iam-policy", f"gs://{name}"])
        bindings = iam.get("bindings", []) if isinstance(iam, dict) else []
        results.append(
            {
                "name": name,
                "uniform_bucket_level_access": bool(
                    b.get("iamConfiguration", {}).get("uniformBucketLevelAccess", {}).get("enabled", False)
                ),
                "public_access_prevention": b.get("iamConfiguration", {}).get(
                    "publicAccessPrevention", "inherited"
                ),
                "iam_bindings": [
                    {"role": bd.get("role", ""), "members": bd.get("members", [])} for bd in bindings
                ],
            }
        )
    return results


def collect_instances(project):
    instances = run_gcloud(["compute", "instances", "list", "--project", project])
    results = []
    for i in instances:
        sa = (i.get("serviceAccounts") or [{}])[0]
        shielded = i.get("shieldedInstanceConfig", {})
        has_external_ip = any(
            "accessConfigs" in nic and nic["accessConfigs"]
            for nic in i.get("networkInterfaces", []) or []
        )
        results.append(
            {
                "name": i.get("name", ""),
                "has_external_ip": has_external_ip,
                "shielded_secure_boot": bool(shielded.get("enableSecureBoot", False)),
                "shielded_vtpm": bool(shielded.get("enableVtpm", False)),
                "shielded_integrity_monitoring": bool(shielded.get("enableIntegrityMonitoring", False)),
                "service_account_email": sa.get("email", ""),
                "service_account_scopes": sa.get("scopes", []) or [],
            }
        )
    return results


def collect_project_iam(project):
    policy = run_gcloud(["projects", "get-iam-policy", project])
    bindings = policy.get("bindings", []) if isinstance(policy, dict) else []
    return [{"role": b.get("role", ""), "members": b.get("members", [])} for b in bindings]


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--project", required=True)
    args = p.parse_args()

    config = {
        "project_id": args.project,
        "firewall_rules": collect_firewall_rules(args.project),
        "buckets": collect_buckets(args.project),
        "instances": collect_instances(args.project),
        "project_iam_bindings": collect_project_iam(args.project),
    }
    print(json.dumps(config, indent=2))


if __name__ == "__main__":
    main()
