# Deploying OpenCTI to close the evidence gap

This is the deployment half of [`../OpenCTI-Custom-Dashboard-Design.md`](../OpenCTI-Custom-Dashboard-Design.md) — that document specifies the dashboard against OpenCTI's real data model but was written with no running instance behind it. This folder is what turns it into evidence: a real `docker-compose.yml`, run against a host that stays up, with one real connector feeding it real STIX data.

## Before you start: resource sizing

OpenCTI's stack (Elasticsearch, RabbitMQ, MinIO, Redis, the platform, and 3 worker replicas) is heavy — Elasticsearch alone typically wants 2-4GB of JVM heap on top of everything else. If this is going on the same home-lab box already running the Wazuh stack (indexer + manager + dashboard), check available memory first:

```bash
free -h
```

Wazuh's own OpenSearch indexer is already a memory-hungry neighbor. If headroom is tight:
- Keep `ELASTIC_MEMORY_SIZE` in `.env` conservative (`2g` is the default here — don't raise it unless you've confirmed the host can take it).
- Consider bringing this stack up only for the session where you build the Workspace, export it, and take the screenshot, then `docker compose down` it afterward rather than running two heavy indexed-search stacks side-by-side indefinitely.
- If you hit OOM kills, check `docker stats` and `dmesg | grep -i "out of memory"` before assuming it's a config bug.

## Steps

1. **Generate two UUIDs** (`OPENCTI_ADMIN_TOKEN` and `CONNECTOR_MITRE_ID` must each be a distinct valid UUIDv4):
   ```bash
   uuidgen
   uuidgen
   ```
   (or `python3 -c "import uuid; print(uuid.uuid4())"` run twice, if `uuidgen` isn't installed)

2. **Copy and fill in the env file:**
   ```bash
   cp .env.example .env
   ```
   Edit `.env` and replace every `REPLACE-WITH-...` entry with a real value. Check [OpenCTI's docker repo releases](https://github.com/OpenCTI-Platform/docker/releases) for the current stable version tag and set `OPENCTI_VERSION` to match — the platform, worker, and connector images all need to be on the same version.

3. **Bring the stack up:**
   ```bash
   docker compose up -d
   ```
   First boot takes a few minutes — Elasticsearch and the platform both need to initialize. Watch it with:
   ```bash
   docker compose logs -f opencti
   ```
   Wait for a line indicating the platform started successfully before trying to log in.

4. **Log in** at `http://<host-ip>:8080` with `OPENCTI_ADMIN_EMAIL` / `OPENCTI_ADMIN_PASSWORD` from `.env`.

5. **Verify the MITRE ATT&CK connector actually ingested data** — in the OpenCTI UI, go to **Data → Connectors**, confirm `MITRE ATT&CK` shows a recent successful run, then check **Analyses → Techniques** (or similar STIX object views) for real `Attack-Pattern`/`Intrusion-Set`/`Malware` objects. If the connector shows an error state, check its logs:
   ```bash
   docker compose logs connector-mitre
   ```
   The connector's first full run can take a while — MITRE ATT&CK is a large dataset.

6. **Build the Workspace dashboard** exactly as specified in [`../OpenCTI-Custom-Dashboard-Design.md`](../OpenCTI-Custom-Dashboard-Design.md) §3-4: create a new Workspace, add each widget listed in the table with its described query/filter, arrange the three rows as described. Since the MITRE connector only populates ATT&CK reference data (not incidents/alerts specific to an org), the top-row Number widgets tied to org-specific incident data will legitimately read 0 — that's expected and fine to note as-is; the widgets tied to `Attack-Pattern`/`Intrusion-Set`/`Malware`/relationship data should show real populated results.

7. **Export the Workspace config**: in the Workspace view, use OpenCTI's export function to get the Workspace's JSON definition. Save it as `../Evidence/opencti-workspace-export.json`.

8. **Take a real screenshot** of the built dashboard and save it as `../Evidence/opencti-dashboard-screenshot.png` (or `.jpg`).

9. **Bring both files back** — that's what upgrades the design doc's status line from "Methodology / Design Exercise" to real, deployed evidence, the same way the Azure lab and the Nmap/Wireshark real-capture evidence closed their own gaps.

## What NOT to do

Don't fabricate the export/screenshot, and don't claim the dashboard is "live" if you tear the stack down afterward for resource reasons — say explicitly (in the doc, once we update it together) whether it's continuously running or was stood up, verified, and evidence-captured once. Both are legitimate; the doc just needs to say which.
