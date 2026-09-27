# GCP Secure Landing Zone

> **Evidence classification: Infrastructure-as-Code / architecture design — not deployed**

This project defines a GCP organization landing-zone architecture using Terraform. It is intentionally presented as IaC/design evidence, not as a deployed GCP environment.

## Security Objectives

- Organization-level policy guardrails
- Deny-by-default ingress
- No unrestricted VM external IPs
- Centralized audit logging
- Shared VPC architecture
- Folder-level IAM governance
- Uniform bucket-level access
- No secrets committed to source control

## Architecture

```text
GCP Organization
 ├── Bootstrap
 ├── Common
 ├── Production
 ├── Non-Production
 └── Development
       │
       ├── Shared VPC Host
       │     ├── private subnets
       │     ├── Cloud NAT
       │     └── deny-all ingress
       │
       └── Central Logging
             └── organization-level audit sink
```

## IaC Design

Terraform models organization policies, folder structure, Shared VPC networking, centralized logging and IAM controls. The configuration is intended to be reviewed and validated against a real GCP organization before deployment.

## Verification Status

- [x] `terraform fmt -check -diff` — clean
- [ ] `terraform validate` — not completed in the original environment because provider-registry access was unavailable
- [ ] `terraform plan` — requires real GCP organization/billing context
- [ ] `terraform apply` — not performed

No GCP organization, project or billing account is represented as deployed evidence by this project.

## Evidence Standard

The architecture and Terraform source are the evidence. Deployment output must not be inferred from the existence of the code. A future live validation should capture provider validation, plan output, applied policies, folder structure, network controls and deny-policy tests.

## Security Takeaway

A landing zone establishes preventive guardrails before workloads are introduced. Centralized logging, controlled IAM, private-by-default networking and organization-level policy reduce the chance that individual projects drift into insecure configurations.

## Next Validation Step

Run `terraform init`, `terraform validate` and `terraform plan` against an authorized GCP organization, review the plan, then deploy only after the resulting controls have been independently verified.

See [`DEPLOYMENT_CHECKLIST.md`](./DEPLOYMENT_CHECKLIST.md) for the validation sequence.
