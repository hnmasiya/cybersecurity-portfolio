# SOC Automation

> **Evidence classification: Hands-on automation / methodology**

This project demonstrates practical automation for repetitive SOC analyst work using Python, Bash and PowerShell. The objective is to reduce manual processing while keeping security decisions explainable, auditable and human-controlled.

## Workflow

**Alert/log → parse → normalize → IOC extraction → enrichment → classification → prioritization → analyst summary → case/report**

## Engineering Standard

Each automation should document:

1. Problem
2. Manual workflow
3. Inputs
4. Processing
5. Outputs
6. Error handling
7. Testing
8. Limitations

## Human-in-the-Loop

Automation assists the analyst. It does not automatically declare an event malicious or perform destructive containment without an explicitly authorized workflow.

## Outputs

Where applicable, tooling produces JSON, CSV, Markdown or HTML artifacts suitable for review and downstream processing.

## Evidence Integrity

The project deliberately avoids unsupported claims about measured time savings, accuracy, detection rates, false-positive reduction or automated containment. Such metrics should only be reported when measured and retained as evidence.

See [`PLAYBOOK.md`](./PLAYBOOK.md) for the analyst workflow.

## SOC Relevance

The strongest use case is repeatability: normalize evidence consistently, extract useful indicators, prioritize analyst attention and preserve a human decision point before escalation or response.
