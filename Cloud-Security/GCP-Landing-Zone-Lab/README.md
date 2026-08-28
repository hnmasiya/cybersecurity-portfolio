# GCP Secure Landing Zone

> **Status: Infrastructure-as-Code, not yet deployed.** This Terraform has been hand-written and formatting-checked (`terraform fmt`) but not run through `terraform init`/`validate`/`plan` — this build environment can't reach the Terraform provider registry, so full provider-schema validation and an actual `apply` both need to happen against a real GCP organization, the same way the [Azure Windows Server Lab](../Azure-Windows-Server-Lab/README.md) started as IaC-only before it was deployed. No org, project, or billing account backs this yet.

## What this is

A GCP organization landing zone: the foundational structure a real GCP estate is built on top of, before any workload gets deployed into it. Follows Google's standard landing-zone shape rather than inventing a bespoke one:

1. **Organization level** — org-wide policy guardrails (constraints) that apply everywhere, not just to this landing zone's own projects.
2. **Folder structure** — environment folders (bootstrap, common, production, non-prod, development) that every future project gets created under.
3. **Network foundation** — a Shared VPC host project, so every service project attaches to one centrally-managed network instead of each spinning up its own.
4. **Security and logging** — a centralized logging project with an organization-wide aggregated sink, so every project's audit logs land in one place regardless of which folder it's created under later.

## Architecture

```
                         organizations/{org_id}
                                  │
              ┌────────────┬──────┴──────┬─────────────┬──────────────┐
              │            │             │             │              │
        fldr-bootstrap  fldr-common  fldr-production  fldr-nonprod  fldr-development
                            │
              ┌─────────────┴─────────────┐
              │                           │
     Shared VPC Host Project      Centralized Logging Project
     ┌─────────────────────┐      ┌──────────────────────────┐
     │ vpc-shared-prod      │      │ org-audit-logs bucket     │
     │  ├─ subnet-app        │      │  ← org_sink (include_    │
     │  ├─ subnet-data       │      │    children = true)      │
     │  ├─ Cloud NAT (both)  │      └──────────────────────────┘
     │  ├─ deny-all-ingress  │
     │  └─ allow-internal    │
     └─────────────────────┘
```

Org policy guardrails applied at the `organizations/{org_id}` node (so they bind every folder/project below, present and future):
- `iam.allowedPolicyMemberDomains` — only principals in this org's own domain can be granted IAM roles anywhere in the org.
- `iam.disableServiceAccountKeyCreation` — no long-lived service account key files, org-wide.
- `compute.vmExternalIpAccess` — deny-all: no VM anywhere in the org gets an external IP unless a more specific policy at a lower node explicitly overrides it.
- `storage.uniformBucketLevelAccess` — enforced everywhere, closing off per-object ACLs as a bucket-security bypass.

## Security design choices

- **Deny-by-default networking.** The Shared VPC has an explicit `deny-all-ingress` rule at low priority (65534) and only one narrow `allow-internal` rule above it — there is no implicit allow-all the way GCP's *default* auto-created network would have.
- **No external IPs, but instances still get updates.** The org policy denies external IPs everywhere; Cloud NAT (one per region, wired to each subnet's router) is how private instances still reach the internet for package installs without ever being reachable from it.
- **Logging is centralized and can't be silently skipped.** The org-level sink (`include_children = true`) captures every project's audit logs, including ones created later under any folder — logging isn't something each new project owner has to remember to wire up themselves.
- **IAM bound at the folder, not the project.** `google_folder_iam_member` grants (e.g. `security-team` viewer access on the whole `production` folder) apply to every project created under that folder later, rather than needing to be re-applied per-project.
- **No secrets in git.** `org_id`, `billing_account`, and `domain` all have no defaults in `variables.tf` — Terraform refuses to apply without them. Real values go in a local `terraform.tfvars` (gitignored); `terraform.tfvars.example` shows the shape without real values.

## Verification done so far

- [x] `terraform fmt -check -diff` — clean (no formatting drift)
- [ ] `terraform validate` — **not run**; this build environment's network policy blocks `registry.terraform.io`, so the `google`/`google-beta` provider schema can't be downloaded here. Needs to run from an environment with real registry access.
- [ ] `terraform plan` / `terraform apply` — **not run**; needs a real GCP organization ID, billing account, and domain.

## Next step to close this gap

Exactly the same path the Azure lab took: run this from a real machine/Cloud Shell with registry access and a real GCP org — `terraform init && terraform validate && terraform plan` first, then `apply` once the plan looks right, then bring back the real output (a resource list, the applied org policies, evidence the deny-all-ingress rule actually blocks what it should) as evidence, the same way `Evidence/azure-resource-list.txt` proves the Azure lab's deployment.

**When you have GCP organization access**, follow [`DEPLOYMENT_CHECKLIST.md`](./DEPLOYMENT_CHECKLIST.md) — it contains a step-by-step walkthrough including:
- Prerequisites verification (org ID, billing account, domain)
- `terraform init`/`validate`/`plan`/`apply` commands
- Evidence capture (outputs, org policies, folder structure, deny-policy test)
- Troubleshooting guide
- Success criteria checklist
