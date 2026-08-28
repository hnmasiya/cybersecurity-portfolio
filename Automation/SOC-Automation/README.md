# SOC Automation

## Purpose

This project demonstrates practical automation for repetitive SOC analyst work using Python, Bash and PowerShell.

The focus is not automation for its own sake.

The objective is to reduce repetitive processing while keeping security decisions explainable and auditable.

## Workflow

**Alert/log → parse → normalize → IOC extraction → enrichment → classification → prioritization → analyst summary → case/report**

## Architecture

```
              SIEM / Log Source
                     |
                     v
              Event ingestion
                     |
                     v
                Normalizer
                     |
          +----------+----------+
          |          |          |
         IOC       Host        User
       extraction  context     context
          |          |          |
          +----------+----------+
                     |
                     v
                 Enrichment
                     |
                     v
                Classification
                     |
                     v
                 Prioritization
                     |
                     v
              Analyst decision
                     |
             +-------+-------+
             |               |
          Escalate         Close
             |
             v
       Case/report output
```

## Automation outputs

Where appropriate:
- JSON
- CSV
- Markdown
- HTML

## Engineering requirements

Each automation should document:
1. Problem
2. Manual workflow
3. Inputs
4. Processing
5. Outputs
6. Error handling
7. Testing
8. Limitations

## Human-in-the-loop

Automation assists the analyst.

It does not automatically declare an event malicious or perform destructive containment without an explicitly authorized workflow.

## Evidence integrity

Do not claim:
- measured time savings
- accuracy
- detection rates
- false-positive reduction
- automated containment

unless those outcomes have actually been measured and retained as evidence.

See `PLAYBOOK.md` for the analyst workflow.
