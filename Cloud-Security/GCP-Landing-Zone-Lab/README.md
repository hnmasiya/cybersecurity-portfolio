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


---

# 20-Section Evidence-First Case Study Record

> **Standard:** Permanent portfolio case-study standard. This record is an explicit mapping of this lab to the repository's 20-section evidence framework. Existing technical detail and retained artifacts above remain authoritative; this section does not create new execution claims.

**Evidence state:** ARCHITECTURE / METHODOLOGY

## 1. Scenario
The scenario documented in this README is the authoritative scenario. No additional scenario is inferred.

## 2. Business / Technical Context
The technical context is the environment, dataset, infrastructure, or simulation already described above. Production impact is not claimed unless supported by retained evidence.

## 3. Objective
The objective is the investigation, validation, engineering, or security outcome explicitly stated above.

## 4. Environment / Scope
Scope is limited to the hosts, applications, cloud resources, datasets, simulations, and repositories explicitly identified in this case study. No third-party scope is implied.

## 5. Tools Used
Tools are only those named in the existing case-study content and retained artifacts. Tool presence in the repository is not treated as proof that a tool was executed.

## 6. Investigation / Methodology
The methodology follows the documented workflow above: collect or generate authorized evidence, analyze it, validate findings, document interpretation, and preserve limitations.

## 7. Commands / Scripts Used
Executable commands and scripts remain in the existing lab paths. Only commands actually documented or retained by this lab are treated as executed evidence.

## 8. Evidence
Primary evidence is the retained files, logs, screenshots, datasets, reports, scripts, or validation outputs referenced above. Missing evidence is not reconstructed.

## 9. Indicators / Observations
Indicators and observations are limited to results explicitly reported in this README or its retained evidence. Observations are not automatically treated as malicious activity.

## 10. Analysis
Analysis separates observed facts from analyst interpretation. Where a finding has a documented benign explanation, that explanation is preserved rather than escalated into an unsupported incident claim.

## 11. Findings
Findings are those explicitly documented above or in retained analysis artifacts. A detector firing is treated as a finding requiring context, not proof of compromise by itself.

## 12. Risk / Impact
Risk and impact are described only where supported by the lab evidence and scope. Production business impact, customer impact, or breach status is not inferred from laboratory results.

## 13. Recommended Actions
Recommended actions are limited to the remediation, hardening, validation, containment, or follow-up actions supported by the documented findings.

## 14. Detection / Monitoring Opportunities
Relevant detection, logging, monitoring, alerting, baseline, and validation opportunities are those demonstrated or explicitly proposed by this case study. Unvalidated detections remain unvalidated.

## 15. MITRE ATT&CK Mapping
MITRE ATT&CK mappings are retained where already documented and are not expanded solely to make the case study appear more complete. Unsupported mappings remain omitted.

## 16. Lessons Learned
The lessons are derived from the documented execution, validation, troubleshooting, or methodology. Failed approaches are retained where they materially explain how the final result was reached.

## 17. Skills Demonstrated
Skills are limited to capabilities evidenced by the documented work: investigation, detection engineering, scripting, telemetry analysis, cloud/security configuration, reporting, or related activities actually represented by the lab.

## 18. Portfolio / SOC Relevance
This case study demonstrates how the documented work maps to SOC, detection engineering, DFIR, cloud security, vulnerability management, or security automation workflows without claiming production employment experience.

## 19. Evidence & Limitations
Evidence classification is explicit: **ARCHITECTURE / METHODOLOGY**. Synthetic, offline, architectural, pending, or virtual evidence must not be represented as live production experience. Dataset size, environmental constraints, missing telemetry, and unperformed steps remain limitations.

## 20. References / Source Material
References are the existing linked artifacts, scripts, reports, datasets, vendor documentation, standards, and source material already retained by this lab. No external execution evidence is implied by a reference link alone.

### Evidence Integrity Statement
This case study is complete only to the extent supported by retained evidence. **No fabricated metrics, certifications, incidents, production claims, or execution results are introduced by this standardization.**
