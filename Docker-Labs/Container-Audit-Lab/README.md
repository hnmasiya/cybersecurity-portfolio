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

**Complete — validated against both synthetic and a real, live Docker host.**

The synthetic dataset includes one fully-hardened container config (pinned
tag, non-root user, a non-secret env value, no privileged mode, no
docker.sock mount, bridge networking) to demonstrate the audit logic
doesn't flag correctly-configured containers.

## Real Docker host validation

[`Scripts/collect_container_configs.py`](./Scripts/collect_container_configs.py)
collects real running-container configuration via `docker inspect`
(image, user, env var key names, privileged flag, mounts, network mode),
transformed into the schema the auditor expects, and was run against a
real home-lab Docker host running 8 containers (Wazuh Manager/
Indexer/Dashboard, RustDesk relay/signal servers, Portainer, Juice Shop,
Wireshark):

```
python3 Scripts/collect_container_configs.py > Data/real-container-configs.json
python3 Scripts/container_config_auditor.py --input Data/real-container-configs.json --output Evidence/real-container-audit.json
```

Result: **14 findings across 8 containers** (1 CRITICAL, 10 HIGH, 3 MEDIUM)
— real, unfiltered output, interpreted honestly:

- **5 containers running as root** (`wazuh-manager`, `hbbs`/`hbbr`
  RustDesk relay/signal servers, `portainer`, `wireshark`) — genuine
  findings. Two of them (`portainer`, `wireshark`) are arguably
  justified by what the container needs to do (Portainer manages the
  Docker daemon itself; Wireshark needs raw packet-capture access), but
  "needed for the job" and "not a real finding" are different things —
  both are reported as-is rather than pre-excused.
- **5 hardcoded secrets** (`INDEXER_PASSWORD`, `API_PASSWORD` on the
  Manager; `INDEXER_PASSWORD`, `DASHBOARD_PASSWORD`, `API_PASSWORD` on
  the Dashboard) — these are literal plaintext passwords in the Wazuh
  official Docker Compose quickstart's environment variables, a real
  and known tradeoff of that deployment pattern, not a mistake unique to
  this lab.
- **1 CRITICAL: Docker socket mounted into `portainer`** — genuine and
  by design: Portainer requires access to the Docker socket to manage
  containers on the host, which is exactly the classic container-escape
  vector this check exists to catch. A real, accepted risk tradeoff for
  running Portainer at all, not an oversight.
- **3 unpinned (`latest`) image tags** (`portainer`, `juice-shop`,
  `wireshark`) — realistic for a home lab pulling current images rather
  than pinning to specific digests.
- **`wazuh-indexer` produced zero findings** — not every container in
  the same stack is flagged; a raw, unfiltered auditor still correctly
  distinguishes a clean config from a flagged one.

The collector never writes real secret values to disk: env var values
are replaced with a fixed sentinel before being written, while still
preserving the fact that a real, non-empty value was set - which is all
the CTR-003 check actually needs. Real evidence:
[`Data/real-container-configs.json`](./Data/real-container-configs.json)
and [`Evidence/real-container-audit.json`](./Evidence/real-container-audit.json).
