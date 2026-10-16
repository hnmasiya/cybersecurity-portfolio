# Incident Response and Detection Governance Playbook

**Use:** lab exercise and documentation template. Not a record of a real production incident.

## Triage and decision points

1. **Validate alert:** check rule ID, event time, source, host, user, process lineage and whether required telemetry is present.
2. **Establish scope:** identify related events and affected assets using authorized logs. Preserve original timestamps and source references.
3. **Assess confidence:** distinguish confirmed facts, hypotheses and unknowns. Check known administrative activity and benign controls.
4. **Escalate:** use the organization's severity matrix and escalation contacts. If the scope or impact is unclear, record that uncertainty.
5. **Containment decision:** recommend containment only when evidence, business impact and authority support it. Any actual isolation, blocking or account disablement requires an authorized operator and approved procedure.
6. **Preserve evidence:** record source, collection time, collector, hash where appropriate, access history and storage location. Avoid altering original evidence.
7. **Recover and validate:** confirm the approved remediation, monitor for recurrence and verify critical services with the system owner.
8. **Lessons learned:** document detection gaps, telemetry gaps, timeline, decisions, tuning proposals and owners for follow-up.

## Detection rule lifecycle controls

- Rule owner and reviewer
- Version-controlled query and rationale
- Required data sources and fields
- Positive, negative and edge-case tests
- ATT&CK technique mapping justified by evidence
- False-positive review and narrow suppression rationale
- Change history, approval, deployment and rollback reference
- Review date and retirement criteria

## Purple-team collaboration record

When an authorized exercise occurs, record scope approval, test objective, emulation technique, expected telemetry, observed telemetry, detection result, response timeline, gaps, remediation owner and retest evidence. Do not describe a lab simulation as a real purple-team engagement.

## Exercise outcome template

- Exercise ID / date:
- Scope and authorization:
- Scenario and hypothesis:
- Data sources:
- Timeline and evidence references:
- Confirmed facts:
- Inferences / confidence:
- Containment decision and approver:
- Detection changes:
- Retest outcome:
- Lessons learned / owners:
- Limitations:

**Evidence integrity:** leave unknown fields marked pending. Do not invent response times, impact, incident counts, stakeholder approvals or production ownership.
