# GCP Secure Landing Zone — Deployment Checklist

> **This guide is for when you have GCP organization access.** Current Terraform code is ready to deploy; only prerequisites are missing.

---

## ✅ Prerequisites Checklist

Before running `terraform init`/`plan`/`apply`, verify you have:

- [ ] **GCP Organization** (not just a sandbox project)
  - Cloud Identity or Workspace enabled
  - Billing account attached to organization
  - Organization ID (format: `123456789`)

- [ ] **Local machine with Terraform registry access**
  - Cannot deploy from this remote environment (network policy blocks `registry.terraform.io`)
  - Use your local machine, Cloud Shell, or a machine outside this network

- [ ] **gcloud CLI installed and authenticated**
  ```bash
  gcloud init
  gcloud auth application-default login
  ```

- [ ] **Terraform 1.0+** installed locally
  ```bash
  terraform --version
  ```

---

## 🚀 Deployment Steps

### Step 1: Prepare local tfvars file

```bash
cd Cloud-Security/GCP-Landing-Zone-Lab/

# Copy template (never commit real values)
cp terraform.tfvars.example terraform.tfvars

# Edit with YOUR real values
vim terraform.tfvars
# Required values:
# - org_id: "123456789" (your organization ID)
# - billing_account_id: "ABCDEF-123456-GHIJKL" (format: XXXXXX-XXXXXX-XXXXXX)
# - domain: "mycompany.com" (for IAM restrictions)
```

### Step 2: Initialize Terraform

```bash
terraform init
# Downloads google and google-beta provider schemas
# Creates .terraform/lock.hcl
```

### Step 3: Validate configuration

```bash
terraform validate
# Checks syntax, required variables, resource references
# Should output: "Success! The configuration is valid."
```

### Step 4: Review what will be created

```bash
terraform plan -out=tfplan
# Shows all resources to be created
# Saves plan to file for reproducible apply

# Expected resources (~20 total):
# - 1 Organization (modified: org policies added)
# - 5 Folders (bootstrap, common, production, non-prod, development)
# - 2 Projects (Shared VPC host, centralized logging)
# - 1 VPC network (deny-all-ingress, allow-internal)
# - 2 Cloud NAT (one per region)
# - 2 Firewall rules (deny-all, allow-internal)
# - 1 Log sink (organization-wide)
# - 8-10 Organization policies (IAM, compute, storage)
```

### Step 5: Apply the plan

```bash
# Review plan output carefully before applying
terraform apply tfplan

# This will:
# 1. Create all folders under organizations/{org_id}
# 2. Create Shared VPC host project
# 3. Create centralized logging project
# 4. Create VPC network with deny-all-ingress rule
# 5. Create Cloud NAT for each region
# 6. Apply organization-level policies (security guardrails)
# 7. Create org-wide logging sink
```

**Expected output:**
```
Apply complete! Resources added, X changed, X destroyed.
Outputs:
  organization_id = "123456789"
  shared_vpc_host_project_id = "prj-shared-vpc-abcdef"
  logging_project_id = "prj-logging-abcdef"
  shared_vpc_network_name = "vpc-shared-prod"
```

### Step 6: Capture outputs for evidence

```bash
# Save state and outputs
terraform output -json > Evidence/terraform-outputs.json

# Screenshot organization folder structure
gcloud resource-manager folders list --organization={org_id} > Evidence/folders.txt

# Verify org policies applied
gcloud org-policies list --organization={org_id} > Evidence/org-policies.txt

# Test deny-all-ingress: try to create VM with external IP
# Should fail with policy constraint violation:
gcloud compute instances create test-external-ip \
  --zone=us-central1-a \
  --network=vpc-shared-prod \
  --create-disk=size=10GB \
  --address external-ip 2>&1 | tee Evidence/deny-policy-test.txt

# Clean up test VM
gcloud compute instances delete test-external-ip --zone=us-central1-a
```

### Step 7: Document deployment

Create `Evidence/DEPLOYMENT_LOG.md`:

```markdown
# GCP Landing Zone Deployment Log

## Deployment Date
2026-MM-DD HH:MM UTC

## Organization Details
- Organization ID: {org_id}
- Domain: {domain}
- Billing Account: {billing_account_id}

## Resources Created
- [x] 5 Folders (bootstrap, common, production, non-prod, development)
- [x] Shared VPC host project: {project_id}
- [x] Centralized logging project: {project_id}
- [x] VPC network with deny-all-ingress
- [x] Cloud NAT (2 instances)
- [x] Organization policies (8):
  - iam.allowedPolicyMemberDomains
  - iam.disableServiceAccountKeyCreation
  - compute.vmExternalIpAccess
  - storage.uniformBucketLevelAccess
  - [others as defined in Terraform]

## Verification Results
- [x] `terraform plan` matched final state
- [x] Org policies successfully applied
- [x] Deny-all-ingress rule blocks external IP assignment
- [x] Cloud NAT routes traffic for private instances
- [x] Logging sink captures org-wide audit logs

## Issues Encountered
[Document any issues, workarounds, and resolutions]

## Time to Deploy
Approximately {minutes} minutes from `terraform init` to `terraform apply`
```

---

## 🔄 After Deployment

### Commit evidence to repo

```bash
# Add all evidence files
git add Evidence/

# Commit
git commit -m "Deploy GCP Secure Landing Zone; add deployment evidence

Deployed real Terraform IaC against GCP organization (org_id={org_id}).
All 5 folders, 2 core projects, Shared VPC network, Cloud NAT, and 
8 organization policies successfully applied. Deny-all-ingress policy 
verified to block external IP assignment. Org-wide logging sink 
configured. Ready for workload projects to be created under folder 
hierarchy.

Evidence: terraform-outputs.json, org-policies.txt, folders.txt, 
deny-policy-test.txt, DEPLOYMENT_LOG.md"

git push origin fix/gcp-landing-zone-deployment
```

### Update README

Edit `Cloud-Security/GCP-Landing-Zone-Lab/README.md`:

- Change "Status: Infrastructure-as-Code, not yet deployed" to "Status: Deployed"
- Add deployment date
- Update verification section with actual results
- Link to Evidence/ folder

---

## 🚨 Troubleshooting

### "Error: Terraform registry not accessible"
**Solution:** Deploy from a machine with internet access to `registry.terraform.io` (not from this remote environment). Use your local machine or GCP Cloud Shell.

### "Error: Organization not found"
**Solution:** Verify `org_id` in `terraform.tfvars` is correct. Use `gcloud organizations list` to find it.

### "Error: Billing account not found"
**Solution:** Verify billing account format: `XXXXXX-XXXXXX-XXXXXX`. Get list via `gcloud billing accounts list --format="value(name)"`.

### "Error: Insufficient permissions to create folders"
**Solution:** You need `roles/resourcemanager.organizationAdmin` or equivalent at the organization level. Ask your GCP admin to grant this role.

### "Error: Service not enabled"
**Solution:** Terraform automatically enables required services. If you hit this, retry `terraform apply` — sometimes there's a brief propagation delay.

---

## 📋 Success Criteria (Post-Deployment)

- ✅ `terraform apply` completes without errors
- ✅ 5 folders created under organization
- ✅ Shared VPC network created and configured
- ✅ Deny-all-ingress rule blocks external IPs
- ✅ Cloud NAT allows private instances internet access
- ✅ Organization-wide logging sink captures audit logs
- ✅ All 8 organization policies applied
- ✅ Evidence captured (terraform outputs, folder structure, policy tests)
- ✅ Evidence committed to repository
- ✅ Tracker and README updated

---

## 📞 Questions?

Refer to:
- `README.md` — Architecture and security design
- `variables.tf` — Required inputs, defaults, descriptions
- `main.tf` — Resource definitions with comments
- `outputs.tf` — Exported values after deployment

Terraform documentation: https://registry.terraform.io/providers/hashicorp/google/latest/docs
