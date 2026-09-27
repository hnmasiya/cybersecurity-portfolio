# Security Policy

## Scope
This repository is a public cybersecurity portfolio. Security reports concerning repository code, GitHub Actions workflows, generated site assets, or published portfolio infrastructure are welcome.

## Reporting a Vulnerability
Please do not disclose suspected credentials, authentication bypasses, or exploitable vulnerabilities in a public issue.

Use GitHub's private vulnerability reporting/security advisory mechanism when available. Include the affected file or workflow, concise reproduction steps, security impact, evidence sufficient to validate the finding, and suggested mitigation.

Never include live secrets or personal authentication data in a report.

## Repository Change Control
The default branch is protected by an active GitHub ruleset. Security-sensitive changes should use the repository's controlled pull-request change process.

Security-sensitive paths include:
- .github/workflows/
- .github/CODEOWNERS
- .github/dependabot.yml
- SECURITY.md
- security scanning and audit scripts

## Secret Handling
Never commit passwords, API keys, personal access tokens, private keys, session tokens, or other credentials. GitHub Actions credentials must be stored as GitHub Actions secrets and granted only the minimum permissions required.

If a secret is accidentally committed, treat it as compromised immediately and rotate or revoke it. Removing it from the current tree does not make historical exposure safe.

## Safe Disclosure
Allow reasonable time for validation and remediation before public disclosure. Do not access accounts, systems, or data that you do not own or have explicit authorization to test.
