# Career Automation System

This directory is the persistent control plane for the cybersecurity job-search and application workflow.

## Pipeline

Job discovery -> canonicalization -> duplicate detection -> sponsorship verification -> profile/GitHub evidence matching -> requirement-gap analysis -> tailored application package -> ATS readiness -> approval -> authorized submission where supported -> application tracking -> deadline/follow-up monitoring -> interview/assessment preparation.

## Source coverage

See job-sources.json. A source is only reported as active when the current discovery mechanism can actually access it. Board names in the registry are coverage targets, not a claim of exhaustive scraping.

## Application tracker

applications.csv is the persistent application record. It stores the canonical vacancy identity, source/application URLs, sponsorship evidence, match evidence, ATS status, package versions, application state and follow-up dates.

## Packages

Use package-layout.md and application-package-template.md.

## ATS

ats-rules.json defines evidence-safe readiness checks. The validator reports PASS or NEEDS REVISION; it does not invent a numerical ATS score.

## Submission

See submission-policy.md. No CAPTCHA, MFA, anti-bot, access-control, or screening-question bypass is permitted. If an authorized integration is unavailable, the workflow stops at approval and provides the official application URL.

## Privacy and evidence

Never store passwords, MFA codes, session cookies, API keys, or private contact information in public repository files. Training simulations must remain clearly labeled as simulations/virtual work experiences rather than employment.
