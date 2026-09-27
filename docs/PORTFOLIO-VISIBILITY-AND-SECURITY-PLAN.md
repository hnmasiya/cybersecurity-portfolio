# Portfolio Visibility & Outreach Plan

## Objective

Increase qualified discovery of `hnmasiya/cybersecurity-portfolio` among cybersecurity recruiters, SOC/security hiring managers, practitioners, engineers and learners without artificial engagement, spam, misleading claims, or purchased activity.

## Positioning

**Primary message:** A Security+ certified cybersecurity practitioner with 12+ years of enterprise IT/infrastructure experience, demonstrating SOC analysis, detection engineering, incident response/DFIR, Windows/AD security, network security, cloud security and security automation through documented authorized labs and technical projects.

**Proof pattern:** scenario → environment → telemetry/evidence → analysis → detection/findings → remediation → validation.

## Priority audiences

1. Cybersecurity recruiters and technical sourcers
2. SOC / Security Operations hiring managers
3. Detection engineers and security engineers
4. Incident response / DFIR practitioners
5. IT/security professionals evaluating practical skills
6. Cybersecurity learners who may discover and share useful labs

## Project visibility priorities

### Tier A — lead with these
- Wazuh SIEM / detection engineering
- Windows + Sysmon / endpoint detection
- Azure Windows Server + Wazuh connected endpoint
- Incident Response / DFIR investigations
- Active Directory security
- Nmap + Wireshark / PCAP analysis

### Tier B — supporting proof
- Linux hardening
- Docker/container configuration audit
- Security automation / Python log analysis
- GCP Terraform secure VPC / landing-zone work
- AppSec / SAST

### Tier C — context and breadth
- DVWA
- OWASP Juice Shop
- Google Cybersecurity coursework
- Forage virtual job simulations

The portfolio should not present every project with equal prominence. The first screen should establish SOC/detection capability and enterprise IT-to-security relevance; breadth can follow.

## Discoverability

Recommended GitHub topics:

`cybersecurity`, `soc`, `soc-analyst`, `security-operations`, `detection-engineering`, `wazuh`, `siem`, `incident-response`, `dfir`, `threat-hunting`, `windows-security`, `active-directory-security`, `network-security`, `wireshark`, `nmap`, `security-automation`, `python-security`, `cloud-security`, `terraform-security`, `cybersecurity-portfolio`

Use only topics that accurately describe the repository. GitHub allows up to 20 topics and recommends lowercase, hyphenated topic names. Topics are public and help repositories be discovered by subject area. See GitHub's topic guidance: https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/classifying-your-repository-with-topics

## Content cadence

### Week 1 — SOC / SIEM
Publish a short LinkedIn post showing one Wazuh investigation: scenario, telemetry, detection, finding and remediation. Link directly to the relevant report rather than only the repository root.

### Week 2 — Detection Engineering
Show one custom detection rule mapped to MITRE ATT&CK and explain how it was validated. Keep the post technical and evidence-led.

### Week 3 — Windows / AD
Publish an investigation or hardening lesson from the Windows/Sysmon/AD work. Highlight the connection between enterprise IT experience and security operations.

### Week 4 — Network / DFIR
Publish a PCAP or forensic investigation walkthrough with a concise finding and evidence reference.

Then repeat the cycle with new findings rather than reposting the same promotion.

## Community strategy

### GitHub
Use repository topics, clear descriptions, cross-links and project-specific READMEs. GitHub's own documentation identifies topics, search and Explore as discovery mechanisms.

### Reddit
Participate before promoting. Prefer communities and recurring self-promotion/career threads where permitted. Do not mass-post identical links.

Potentially relevant communities to evaluate against their current rules:
- r/cybersecurity — discussion and career content; self-promotion is restricted, so prioritize useful discussion and permitted recurring threads.
- r/CyberSecurityJobs — cybersecurity employment and career discussion.
- r/SOC — SOC/security-operations discussion.
- r/netsec — technical network/security content; check current rules before posting portfolio material.
- r/github — GitHub projects and self-promotion megathreads.

### LinkedIn
Use the portfolio as evidence behind career-oriented technical posts. Tag technologies and discuss the technical lesson rather than asking for stars.

### Security communities
Prefer communities around Wazuh, DFIR, detection engineering, threat hunting, Blue Team work, cloud security and cybersecurity learning. Contribute useful answers, then reference a project only when it directly supports the discussion.

## Outreach rules

- Never buy GitHub stars, forks, followers or traffic.
- Never use bots to mass-comment or mass-DM.
- Never claim production/client experience for lab work.
- Never describe Forage simulations as employment.
- Link to the exact project/report when relevant.
- Ask for feedback where feedback is genuinely wanted.
- Keep promotional frequency low enough that community participation remains authentic.

## Tracking

Create a monthly baseline for:
- GitHub stars
- forks
- repository views
- unique visitors
- traffic sources/referrers
- profile views
- LinkedIn post impressions
- LinkedIn profile views
- recruiter messages
- portfolio/resume clicks
- job applications where the portfolio was included
- interview requests attributable to portfolio exposure

Interpret these as signals, not proof of causation. A spike after a post is useful evidence of reach, but recruiter engagement and relevant conversations are more meaningful career signals than raw star counts.

## Four-week operating loop

1. Publish one technically useful artifact/post.
2. Share it only where the community permits it.
3. Respond to technical questions.
4. Update the linked project README if feedback exposes a clarity gap.
5. Record traffic/referral signals.
6. Repeat with a different project.

## Outreach templates

### LinkedIn project post

I’ve been building and documenting a hands-on cybersecurity portfolio focused on SOC operations, detection engineering, incident investigation and security automation.

One recent investigation connected Windows/Sysmon telemetry to Wazuh, mapped the detection to MITRE ATT&CK, and documented the evidence and remediation workflow.

I’m sharing the technical write-up for anyone working with SIEM/detection engineering or building a practical security portfolio.

Repository: https://github.com/hnmasiya/cybersecurity-portfolio

Feedback on the investigation methodology is welcome.

### Community introduction

I’ve been documenting authorized cybersecurity labs covering Wazuh/SIEM, Windows and Sysmon, detection engineering, DFIR, network analysis, cloud security and automation.

The goal is to make the evidence reproducible and clearly distinguish observed telemetry from synthetic or methodology-based work.

I’m particularly interested in feedback from practitioners on the investigation and detection methodology.

Portfolio: https://github.com/hnmasiya/cybersecurity-portfolio

### Project announcement

New portfolio write-up: **[PROJECT NAME]**

- Scenario:
- Environment:
- Evidence collected:
- Detection/analysis:
- MITRE ATT&CK mapping:
- Remediation:
- Validation:

Full technical documentation: [PROJECT LINK]

## Security hardening backlog

### Completed in this branch
- Pin TruffleHog GitHub Action to an immutable release commit instead of `@main`.
- Strengthen the README first impression with a recruiter-focused quick view.
- Add direct navigation to the evidence map, tools inventory, featured labs and resume.
- Add visible CI/security-control badges.
- Add direct links from the featured-evidence table to major project areas.

### Repository settings to enforce on main
- Require pull requests before merging.
- Require the security scan and portfolio quality checks.
- Disable force pushes.
- Prevent branch deletion.
- Require conversation resolution where practical.
- Limit bypass permissions.
- Review GitHub Actions permissions and replace broad PAT use with least-privilege `GITHUB_TOKEN` where technically possible.
- Pin third-party Actions to immutable SHAs.

### Account security
Review GitHub account 2FA/passkeys, active sessions, SSH keys, personal access tokens and recovery methods directly in GitHub. These are account-level controls and are not exposed through the repository content audit.

## Current limitations

Repository topics, repository description/social-preview metadata, branch protection/rulesets and account-level security settings require GitHub repository/account administration controls. This document records the recommended configuration; it does not claim those settings have been changed unless GitHub reports the change directly.
