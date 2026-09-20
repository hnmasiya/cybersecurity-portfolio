# Career Operations System

This public directory documents the architecture and evidence-safe methodology for the career operations system.

## Public/private separation

This repository is public and must contain only reusable architecture, templates, validation logic, sanitized examples, and portfolio-facing documentation.

**Never store real job applications or personal career records here.**

The private career workspace must contain actual job discoveries, application tracker records, employer/application history, application dates and statuses, tailored resumes and cover letters, sponsorship evidence, interview questions and answer preparation, recruiter information, follow-up dates, and personal contact information.

The public repository may demonstrate the system without exposing those records.

## Pipeline

Job discovery -> canonicalization -> duplicate detection -> sponsorship verification -> verified profile/GitHub evidence matching -> requirement-gap analysis -> tailored application package -> ATS readiness -> job-specific interview preparation -> user approval -> authorized submission -> application tracking -> deadline/follow-up monitoring.

## Application tracker

application-schema.csv defines the fields for the private application tracker. The real tracker must not be committed to this public repository.

The tracker is designed to record employer, role, country/location, work arrangement, source/application URL, posting/deadline, sponsorship status and evidence, match evidence, gaps, resume/cover-letter versions, GitHub evidence, ATS status, application status, dates applied, follow-ups, next action, and notes.

## Interview preparation

Every high-relevance vacancy should receive a job-specific interview pack in the private workspace containing 10–20 likely technical questions, 10 behavioral questions, role-specific questions, SOC/cybersecurity scenarios where relevant, STAR answer guidance, questions derived from employer requirements, technology-specific questions, questions grounded in verified candidate experience, GitHub project questions, Forage virtual job simulation questions, likely screening questions, practical/technical assessment preparation, questions for the interviewer, evidence-safe model answer guidance, and explicit no-claim/evidence-gap reminders.

## ATS and submission

ats-rules.json defines evidence-safe readiness checks. submission-policy.md defines safe submission rules. No CAPTCHA, MFA, anti-bot, access-control, or screening-question bypass is permitted.

## Evidence and privacy

Never store passwords, MFA codes, session cookies, API keys, private contact information, application history, recruiter data, or tailored personal documents in this public repository. Training simulations must remain clearly labeled as simulations/virtual work experiences rather than employment.

## Portfolio-facing description

Career Operations System — automated job discovery, evidence-based matching, ATS validation, application tracking, job-specific interview preparation, and follow-up monitoring, with private career records kept outside this public portfolio repository.
