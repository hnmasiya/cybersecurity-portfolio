# OpenCTI Custom SOC Dashboard: Design

> **Status: Design specified; real instance deployed and connector-verified; this specific Workspace not yet built.** This is a real, specific dashboard
> design against OpenCTI's actual Workspace/widget model and STIX data model —
> not a vague mockup. The stack in [`Deployment/`](Deployment/) has since been
> run against a real Docker host: all 9 containers came up, and the built-in
> MITRE ATT&CK connector genuinely imported real STIX data (181 Intrusion-Set
> and 273 Malware objects, independently observed live in the platform's UI).
> What's not yet done is building *this specific* Workspace against that
> running instance and exporting its config/screenshot — deprioritized this
> pass due to host memory constraints running two OpenSearch-based stacks side
> by side. For the remaining step, see [Closing this gap](#closing-this-gap).

## Metadata
* **Platform:** OpenCTI (open-source Cyber Threat Intelligence platform)
* **Analyst:** Hazvinei Masiya
* **Date:** 2026-08-27

---

## 1. Objective

Design a single custom OpenCTI Workspace dashboard giving a SOC analyst everything needed for a shift-start triage pass in one screen: active alerts, open incidents, indicator volume, unpatched vulnerabilities, response-time trend, and which threat actors/TTPs are currently linked to the organization's data — without having to navigate OpenCTI's separate Analyses / Observations / Threats views individually.

## 2. Why OpenCTI specifically

OpenCTI models everything as STIX 2.1 objects and relationships (`Indicator`, `Malware`, `Intrusion-Set`, `Campaign`, `Vulnerability`, `Report`, `Incident`, plus relationships like `indicates`, `uses`, `targets`, `attributed-to`). Its Workspace dashboards aren't static images — each widget is a saved, real GraphQL query (`stixCoreObjectsDistribution`, `stixCoreRelationshipsMultiTimeSeries`, etc.) against that graph, filterable by entity type, marking, label, and time window. Designing "a dashboard" for OpenCTI means designing the actual filter/query for each widget, not just a layout.

## 3. Widget-by-widget design

| Widget | OpenCTI widget type | Backing query (conceptual) | Why it's here |
|---|---|---|---|
| Active critical alerts | Number | Count of `Indicator` where `x_opencti_score >= 80` and `revoked = false` | Top-line triage signal — the "how bad is it right now" number |
| Open incidents | Number | Count of `Incident` where `status != closed` | Second top-line number; pairs with alerts to show detection-vs-response load |
| IOCs detected today | Number | Count of `Indicator` created in last 24h, filtered to this org's detection connectors | Volume trend for the current shift, not all-time |
| Unpatched vulnerabilities | Number | Count of `Vulnerability` linked via `targets` to internal `Software`/`Asset` observables with no linked `Remediation` | Ties CTI data to the org's own asset exposure, not just external feed noise |
| Incidents by severity/status | Horizontal bar chart | `Incident` distribution grouped by `severity`, stacked by `status` | Shows backlog shape, not just a single count |
| Mean response time by severity | Line/area chart | Time-series of `(incident.response_date - incident.created_date)`, grouped by `severity` | Trend, not snapshot — is response time improving or degrading |
| Playbooks executed | Vertical bar chart | Count of OpenCTI Playbook executions per day, last 14 days | Shows how much triage is already automated vs. manual |
| IOCs detected (table) | List | `Indicator` list: type, value, source connector, confidence, first-seen — sorted by score desc | The actual working list an analyst pivots from |
| Relationship evolution | Donut chart | `stixCoreRelationships` distribution by relationship type over the selected time window | Shows whether new data is mostly new indicators, new attributions, or new campaign links |
| TTPs and linked threat actors | List / relationship table | `Intrusion-Set`/`Campaign` objects with count of linked `Attack-Pattern` (MITRE ATT&CK techniques) and last-seen date | Bridges IOC-level noise to actor-level context |
| Critical vulnerabilities | List | `Vulnerability` list filtered to CVSS >= 9.0 with a `targets` relationship to an internal asset | Same asset-relevance filter as the count widget above, just the detail view |
| Highest-risk assets | List | Internal `Software`/`Asset` objects ranked by count of incoming `targets`/`related-to` relationships from high-score indicators | Answers "what should I look at first," not just "what exists" |
| Threat distribution by type | Donut chart | `stixCoreObjectsDistribution` on `Malware`/`Intrusion-Set`/`Tool` grouped by `malware_types`/`sector` | Gives shape to what's actually hitting the org, not a generic feed summary |

## 4. Dashboard layout

Modeled as a single OpenCTI Workspace with three rows: a top row of the four Number widgets (alerts, incidents, IOCs today, unpatched vulns) for at-a-glance status; a middle row of three trend/breakdown charts (incidents by severity, MTTR trend, playbooks executed); a bottom row of detail lists and relationship widgets (IOC table, relationship evolution, TTPs/threat actors, critical vulnerabilities, highest-risk assets, threat distribution) for the actual pivot-and-investigate work.

## 5. Evidence status

No screenshot or exported Workspace JSON for *this specific dashboard* backs this document yet — that part is still a design, not an observation. What is now observed rather than assumed: a real OpenCTI instance was deployed from [`Deployment/`](Deployment/) against a real Docker host, and the built-in MITRE ATT&CK connector genuinely populated real STIX data (181 Intrusion-Set objects, 273 Malware objects), independently confirmed live in the platform's own UI. Every widget above is specified against OpenCTI's real, current data model and widget types (not invented ones), so it's directly buildable — and the data it would need to run against is now proven to exist for real, not just assumed reachable.

## Closing this gap

The deployment half of this gap is closed: `Deployment/` has a validated `docker-compose.yml` and was run against a real host with a verified working connector. What's left is narrower than before — build this specific Workspace against that running instance (or a fresh one, following the same steps) and export its config plus a screenshot as `Evidence/`. Given the MITRE ATT&CK connector only populates Intrusion-Set/Malware/Attack-Pattern/Course-of-Action data, expect the widgets tied to org-specific Incidents/Vulnerabilities/Indicators to legitimately show empty — that's a scope limit of this connector, not a bug, and worth noting honestly in the eventual write-up rather than treated as a gap to hide.

See [`Deployment/README.md`](Deployment/README.md) for the exact steps.
