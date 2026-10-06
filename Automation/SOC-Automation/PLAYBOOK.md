# SOC Alert Enrichment & Triage Playbook

## Objective

Demonstrate how repetitive analyst work can be automated while retaining human decision-making for security-sensitive actions.

## Workflow

```
Alert
  |
  v
Parse event
  |
  v
Extract IOCs (IP, Domain, Hash, User, Host)
  |
  v
Normalize
  |
  v
Enrich
  |
  v
Classify
  |
  v
Prioritize
  |
  v
Generate analyst summary
  |
  v
Human review
  |
  ├──→ Close / monitor
  |
  └──→ Escalate / contain / response
```

## Automation candidates

- JSON parsing
- IOC extraction
- event normalization
- duplicate alert detection
- enrichment
- severity classification
- Markdown/HTML case generation
- evidence indexing
- executive summary generation

## Safety boundary

Automation should not silently perform destructive response actions.

Actions such as:
- account disablement
- host isolation
- firewall blocking
- deletion
- credential rotation

should require explicit authorization or a controlled test environment.

## Evidence

Measured time savings, detection rates or response improvements are only reported when experimentally measured.

Otherwise results are classified as:
**METHODOLOGY**
