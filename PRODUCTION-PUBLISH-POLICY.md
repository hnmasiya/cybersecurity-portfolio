# Development → Production Publication Policy

## Source of truth

- Development: hnmasiya/cybersecurity-portfolio-dev (private)
- Production: hnmasiya/cybersecurity-portfolio (public)

## Required flow

1. Make changes in the private development repository.
2. Run development validation and security checks.
3. Review the resulting development state.
4. Manually run **Publish Development to Production**.
5. Enter the exact confirmation: `PUBLISH-PRODUCTION`.
6. The workflow creates a production backup, temporarily disables the production rulesets, publishes the development tree as a single production release commit, verifies the result, and restores the rulesets.
7. Production intentionally contains no development GitHub Actions workflows.

## Publication boundary

The development repository contains the automation used to build, validate and publish the portfolio. The public repository is a release artifact, not the working repository.

The workflow excludes the private development publication controls from the public repository. It also creates `PUBLIC-SOURCE-OF-TRUTH.md` in production so the publication relationship is visible to reviewers.

## Safety

- Production main is kept as a single release commit.
- A timestamped production backup branch is created before every publication.
- Production rulesets are restored to active after publication, including when the publication job fails.
- No production publication occurs automatically on a development push.
