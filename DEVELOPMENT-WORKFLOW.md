# Development → Production Workflow

## Repositories

- **Development:** `hnmasiya/cybersecurity-portfolio-dev` — private
- **Production:** `hnmasiya/cybersecurity-portfolio` — public

## Required flow

```
Local development
      ↓
cybersecurity-portfolio-dev
      ↓
validation / testing
      ↓
Promote Dev to Production workflow
      ↓
promotion/* branch in cybersecurity-portfolio
      ↓
Pull Request
      ↓
cybersecurity-portfolio/main
      ↓
GitHub Pages / public portfolio
```

The public repository is the production repository. Development work should not be performed directly on its `main` branch.

## Promotion

The private repository contains:

`.github/workflows/promote-to-production.yml`

Run it manually from GitHub Actions after the development state has been tested.

The workflow:

1. Checks out the current development `main`.
2. Clones the public production repository.
3. Creates a temporary `promotion/dev-<sha>` branch in production.
4. Replaces that branch's working tree with the tested development snapshot.
5. Pushes the promotion branch to the public repository.
6. Opens a Pull Request from the promotion branch to production `main`.

It does **not** merge the production PR automatically.


## Publication boundary

The promotion workflow enforces a public/private boundary.

The following development-only workflow files are never promoted:

- `.github/workflows/promote-to-production.yml`
- `.github/workflows/sync-production-to-dev.yml`
- `.github/workflows/career-intelligence.yml`
- `.github/workflows/career-operations.yml`
- `.github/workflows/career-prep.yml`

Public GitHub Actions workflows are maintained as an explicit production allowlist by the promotion workflow. This prevents a new private development workflow from becoming public merely because it exists in the development repository.

The development repository may therefore use development-specific CI implementations where production-only secrets or automation are required. Production workflow files are preserved and promoted separately through the approved public workflow set.

The promotion workflow also skips Pull Request creation when the resulting production snapshot has no changes.

## Required secret

In the private development repository, create an Actions secret named:

`PRODUCTION_REPO_TOKEN`

The token should be a fine-grained GitHub token restricted to:

`hnmasiya/cybersecurity-portfolio`

with:

- Contents: Read and write
- Pull requests: Read and write
- Metadata: Read

Do not place the token in source files, workflow YAML, README files, or commits.

## Important bootstrap step

The development repository currently contains work from September 27, while the public production repository contains newer changes through October 3. **Do not run the promotion workflow until the development repository has first been reconciled with the current production state.**

This prevents an older development snapshot from accidentally replacing newer production work.

After reconciliation, the development repository becomes the authoritative working source for future portfolio changes.

## Production protection

GitHub repository settings should also protect `main` in the public repository so that direct pushes are blocked and changes require Pull Requests and passing status checks.

Recommended production rule:

- Target: `main`
- Require a Pull Request before merging
- Require status checks to pass
- Block force pushes
- Block branch deletion
- Do not allow direct development on production `main`

The promotion workflow is intentionally separate from the production merge decision.
