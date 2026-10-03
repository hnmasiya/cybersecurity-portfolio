# GCP Project Security Lab

> **Status: Infrastructure-as-Code, validated against the real provider, not yet applied.** `terraform fmt -check -diff` is clean, and `terraform init`/`validate` have since been run from a real machine with registry access — `terraform validate` returned "Success! The configuration is valid." against the actual `google` provider schema. `terraform plan`/`apply` are still pending: a real GCP project was created for this (`gcp-security-lab-2026`), but its billing account is currently closed, blocking `plan`/`apply` and the live audit run. See [Verification done so far](#verification-done-so-far) and [Next steps to close this gap](#next-steps-to-close-this-gap).

## Why this lab, and not the org-level landing zone

[`../GCP-Landing-Zone-Lab/`](../GCP-Landing-Zone-Lab/README.md) is real Terraform too, but it's an *organization*-level landing zone — it creates `google_folder` and `google_org_policy_policy` resources directly under `organizations/{org_id}`, which requires a Cloud Identity/Workspace organization behind the GCP account. A standalone personal/free-tier GCP project (a project with no organization above it) can't apply that Terraform at all — there's no `org_id` for it to reference.

This lab is the project-scoped equivalent: everything here binds to a single existing `project_id`, no organization required. It's a different shape by necessity, not a smaller version of the same thing — where the landing zone lab centralizes policy at the org node for many future projects, this lab hardens one project directly.

## What this is

A hardened GCP project baseline plus a real CSPM (Cloud Security Posture Management) audit tool that checks it:

1. **Custom VPC**, not the project's auto-created `default` network (which ships with permissive implicit-allow rules).
2. **Deny-by-default firewall** — the only inbound path is SSH via Identity-Aware Proxy (IAP), never a direct admin-IP allowlist.
3. **A hardened Compute Engine VM** — Shielded VM (secure boot, vTPM, integrity monitoring), no external IP, OS Login, a scoped-down custom service account instead of the broad-scope default one, and the Cloud Ops Agent installed via startup script so real logs/metrics reach Cloud Logging/Monitoring.
4. **A hardened storage bucket** — uniform bucket-level access and public access prevention both enforced, versioning on.
5. **`Scripts/collect_gcp_config.py` + `Scripts/gcp_cspm_auditor.py`** — a real collector (shells out to `gcloud list`/`describe`/`get-iam-policy`, read-only) and a pure, unit-tested auditor that flags the misconfigurations this Terraform is specifically designed to avoid: open firewall rules, public bucket access, external IPs, disabled Shielded VM protections, the default Compute Engine service account, and primitive roles (`owner`/`editor`) granted to `allUsers`/`allAuthenticatedUsers`.

## Architecture

```
                    Project: {project_id}
                            │
              ┌─────────────┴──────────────┐
              │                            │
     vpc-project-security-lab      Hardened GCS bucket
     ┌──────────────────────┐      (uniform access +
     │ subnet-lab (/24)      │      public access
     │  ├─ deny-all-ingress  │      prevention enforced)
     │  ├─ allow-iap-ssh     │
     │  │   (35.235.240.0/20 │
     │  │    only — no admin-│
     │  │    IP allowlist)   │
     │  ├─ allow-internal    │
     │  ├─ Cloud Router+NAT  │
     │  └─ hardened-lab-vm   │
     │      (Shielded VM,    │
     │       no external IP, │
     │       OS Login,       │
     │       custom scoped   │
     │       service account)│
     └──────────────────────┘
```

## Security design choices

- **IAP instead of an admin-IP allowlist.** The [Azure lab](../Azure-Windows-Server-Lab/README.md) locks RDP to `admin_source_ip`, which goes stale the moment that IP changes. GCP's Identity-Aware Proxy is a stronger pattern available here: SSH is only reachable from Google's fixed `35.235.240.0/20` TCP-forwarding range, gated by the `roles/iap.tunnelResourceAccessor` IAM role rather than a source IP at all — connect with `gcloud compute ssh --tunnel-through-iap`, no firewall change needed when your location changes.
- **No external IP on the VM, ever.** Cloud NAT (one router per region) is how the private VM still reaches the internet for updates, without ever being reachable from it.
- **Shielded VM by default.** Secure boot, vTPM, and integrity monitoring are all explicitly enabled, not left at provider defaults.
- **A scoped custom service account, not the default one.** The VM's service account (`lab-vm-sa`) only holds `roles/logging.logWriter` and `roles/monitoring.metricWriter` — not the broad `roles/editor` the project's default Compute Engine service account traditionally carries. The auditor's `GCP-007` check exists specifically to catch a VM left on that default account.
- **Bucket access is enforced, not just configured.** `public_access_prevention = "enforced"` is a hard block on any public IAM binding ever succeeding on this bucket — not just a setting that a later change could quietly weaken.
- **No secrets in git.** `project_id` and `bucket_name` have no defaults in `variables.tf` — Terraform refuses to apply without them, matching the same pattern as the Azure and landing-zone labs.

## The CSPM audit tool

`Scripts/gcp_cspm_auditor.py` is a general-purpose GCP misconfiguration auditor, not a check that only ever passes against this specific Terraform — it flags the same issues (open firewall rules, public buckets, external IPs, disabled Shielded VM, default service accounts, public primitive-role grants) regardless of what actually created the resources. Run against a project deployed from this Terraform as designed, it's expected to report **zero findings** — the same honest "hardened by design, verified by a real audit tool, 0 findings" result the [Linux Hardening Lab](../../Linux-Security/Hardening-Lab/README.md) already established for a host, applied here to a cloud project instead. A finding would mean either the Terraform drifted from what's documented above, or something in the project predates/exists outside this Terraform.

19 unit tests cover both scripts' logic in [`tests/test_gcp_cspm_auditor.py`](../../tests/test_gcp_cspm_auditor.py) — including that a hardened config produces zero findings and that legitimate ownership (a primitive role granted to a real account, not `allUsers`) is correctly *not* flagged.

## Verification done so far

- [x] `terraform fmt -check -diff` — clean (no formatting drift)
- [x] Manual resource/attribute review against the `google` provider's documented schema (every resource type and argument here mirrors what the already-applied [landing zone lab](../GCP-Landing-Zone-Lab/README.md) used, cross-checked individually rather than assumed correct by similarity)
- [x] `gcp_cspm_auditor.py` unit-tested (19 tests, `pytest tests/test_gcp_cspm_auditor.py`) and smoke-tested against a synthetic config matching this Terraform's intended output — reports 0 findings, as designed
- [x] `terraform init` / `terraform validate` — run from a real machine against the actual `google` provider registry: **"Success! The configuration is valid."**
- [ ] `terraform plan` / `terraform apply` — **not run**; a real GCP project (`gcp-security-lab-2026`) exists, but its billing account is currently closed
- [ ] `collect_gcp_config.py` against a real project — **not run**; blocked on the same billing issue above

## Next steps to close this gap

Run this from a real machine or Cloud Shell with registry access and an authenticated `gcloud` CLI:

```bash
cd Terraform
cp terraform.tfvars.example terraform.tfvars   # fill in project_id + bucket_name
terraform init
terraform validate
terraform plan -out=tfplan
# review the plan, then:
terraform apply tfplan
```

Once applied, run the real CSPM audit against the live project and bring back both the Terraform output and the audit result as evidence:

```bash
cd ../Scripts
python3 collect_gcp_config.py --project YOUR_PROJECT_ID > /tmp/gcp_config.json
python3 gcp_cspm_auditor.py --input /tmp/gcp_config.json --output ../Evidence/real-cspm-audit.json
```

Save `terraform apply`'s resource summary (or `terraform show`) as `Evidence/gcp-resource-list.txt`, the same way `Evidence/azure-resource-list.txt` documents the Azure lab's deployment. When you're done with the lab, `terraform destroy` tears it down to stop billing — the VM and NAT gateway are the only meaningfully billed resources here.
