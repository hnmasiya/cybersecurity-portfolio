# Container Configuration Security Audit Lab

This project demonstrates an offline container security audit using
synthetic container build/runtime configuration, covering common
misconfigurations from the CIS Docker Benchmark and MITRE ATT&CK for
Containers.

## Checks

- Container runs as root (missing/`root` `USER`)
- Unpinned base image tag (`latest` or no tag)
- Hardcoded secret in an environment variable
- Container running in privileged mode
- Docker socket mounted into the container (classic escape vector)
- Container using host network mode

Findings are mapped to MITRE ATT&CK where applicable.

## Validation

Run:

`python3 Scripts/container_config_auditor.py --input Data/synthetic-container-configs.json --output Evidence/container-audit.json`

Results are written to `Evidence/container-audit.json`.

## Current status

**Offline / synthetic validation.**

A live Docker daemon/registry is not currently claimed as evidence. The
synthetic dataset includes one fully-hardened container config (pinned
tag, non-root user, a non-secret env value, no privileged mode, no
docker.sock mount, bridge networking) to demonstrate the audit logic
doesn't flag correctly-configured containers.
