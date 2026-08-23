# Cloud Security Posture Assessment: AWS Infrastructure Audit

> **Status: Methodology / Illustrative Scenario.** This report demonstrates
> how I structure a CSPM finding and remediation write-up. It is not a
> claim of a live AWS account audit in this portfolio — no Prowler output,
> CloudTrail export, or account backs this specific scenario. The
> supporting `../IAM-Policies/least-privilege-policy.json` and
> `../Detection-Rules/suspicious_iam_modifications.sql` in this folder are
> real, reviewable IAM/detection-engineering artifacts, independent of
> this narrative scenario.

## Metadata
* **Case ID:** CSPM-2026-0822-01
* **Analyst:** Hazvinei Masiya
* **Environment:** Multi-Region Cloud Infrastructure (Production Sandbox)
* **Classification:** Misconfiguration Audit & Least-Privilege Remediation
* **Date:** 2026-08-22

---

## 1. Executive Summary
An automated security posture review using Prowler against CIS AWS Benchmarks revealed critical risk findings. Misconfigurations included public S3 bucket read permissions, overly permissive IAM wildcard roles (Admin access), and disabled CloudTrail logging in secondary regions.

---

## 2. Technical Findings & Remediation

### S3 Storage Misconfigurations
* **Finding:** Bucket `corp-backup-vault-2026` had public read/write ACLs enabled.
* **Risk:** Potential exfiltration of sensitive database backups.
* **Remediation:** Enforced S3 Block Public Access across all organizational buckets.

### IAM Policy Over-Privileging
* **Finding:** Service account `deployer-bot` assigned `AdministratorAccess` inline policy.
* **Remediation:** Replaced with a scoped least-privilege policy restricting actions strictly to CodeDeploy and S3 deployment prefixes.
